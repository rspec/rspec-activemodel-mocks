# frozen_string_literal: true
require 'active_support'
require 'active_support/core_ext/object/to_param'
require 'active_model'

module RSpec::ActiveModel::Mocks
  class IllegalDataAccessException < StandardError; end
  module Mocks
    module ActiveModelInstanceMethods
      # Stubs `persisted?` to return false and `id` to return nil
      # @return self
      def as_new_record
        RSpec::Mocks.allow_message(self, :persisted?).and_return(false)
        RSpec::Mocks.allow_message(self, :id).and_return(nil)
        self
      end

      # Returns true by default. Override with a stub.
      def persisted?
        true
      end

      # Returns false for names matching <tt>/_before_type_cast$/</tt>,
      # otherwise delegates to super.
      def respond_to?(message, include_private=false)
        message.to_s =~ /_before_type_cast$/ ? false : super
      end
    end

    # Starting with Rails 4.1, ActiveRecord associations are inversible
    # by default. This class represents an association from the mocked
    # model's perspective.
    #
    # @private
    class Association
      attr_accessor :target, :inversed

      def initialize(association_name)
        @association_name = association_name
      end

      def inversed_from(record)
        self.target = record
        @inversed = !!record
      end
    end

    module ActiveRecordInstanceMethods
      # Stubs `persisted?` to return `false` and `id` to return `nil`.
      def destroy
        RSpec::Mocks.allow_message(self, :persisted?).and_return(false)
        RSpec::Mocks.allow_message(self, :id).and_return(nil)
      end

      # Transforms the key to a method and calls it.
      def [](key)
        send(key)
      end

      # Rails>4.2 uses _read_attribute internally, as an optimized
      # alternative to record['id']
      alias_method :_read_attribute, :[]

      # Returns the opposite of `persisted?`
      def new_record?
        !persisted?
      end

      # Returns an object representing an association from the mocked
      # model's perspective. For use by Rails internally only.
      def association(association_name)
        @associations ||= Hash.new { |h, k| h[k] = Association.new(k) }
        @associations[association_name]
      end
    end

    # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity

    # Creates a test double representing `string_or_model_class` with common
    # ActiveModel methods stubbed out. Additional methods may be easily
    # stubbed (via add_stubs) if `stubs` is passed. This is most useful for
    # impersonating models that don't exist yet.
    #
    # ActiveModel methods, plus <tt>new_record?</tt>, are
    # stubbed out implicitly.  <tt>new_record?</tt> returns the inverse of
    # <tt>persisted?</tt>, and is present only for compatibility with
    # extension frameworks that have yet to update themselves to the
    # ActiveModel API (which declares <tt>persisted?</tt>, not
    # <tt>new_record?</tt>).
    #
    # `string_or_model_class` can be any of:
    #
    #   * A String representing a Class that does not exist
    #   * A String representing a Class that extends ActiveModel::Naming
    #   * A Class that extends ActiveModel::Naming
    def mock_model(string_or_model_class, stubs={})
      @__rspec_active_model_mocks ||= Hash.new { |h, k| h[k] = [] }

      if String === string_or_model_class
        if Object.const_defined?(string_or_model_class)
          model_class = Object.const_get(string_or_model_class)
        else
          model_class = Object.const_set(string_or_model_class, Class.new do
            # rubocop:disable  Style/SingleLineMethods
            extend ::ActiveModel::Naming
            def self.primary_key; :id; end

            # For detection of being a valid association in 7+
            def self.<(other); other == ActiveRecord::Base; end
            def self._reflect_on_association(_other); nil; end
            def self.composite_primary_key?; false; end
            def self.has_query_constraints?; false; end
            def self.param_delimiter; "-"; end
            # rubocop:enable  Style/SingleLineMethods
          end)
        end
      else
        model_class = string_or_model_class
      end

      unless model_class.kind_of? ::ActiveModel::Naming
        raise ArgumentError, <<-EOM
The mock_model method can only accept as its first argument:
* A String representing a Class that does not exist
* A String representing a Class that extends ActiveModel::Naming
* A Class that extends ActiveModel::Naming

It received #{model_class.inspect}
        EOM
      end

      stubs = { :id => next_id }.merge(stubs)
      stubs = { :persisted? => !!stubs[:id],
                :destroyed? => false,
                :marked_for_destruction? => false,
                :valid? => true,
                :blank? => false }.merge(stubs)

      double("#{model_class.name}_#{stubs[:id]}", stubs).tap do |m|
        if model_class.method(:===).owner == Module && !stubs.key?(:===)
          allow(model_class).to receive(:===).and_wrap_original do |original, other|
            @__rspec_active_model_mocks[model_class].include?(other) || original.call(other)
          end
        end
        @__rspec_active_model_mocks[model_class] << m
        msingleton = class << m; self; end
        msingleton.class_eval do
          include ActiveModelInstanceMethods
          include ActiveRecordInstanceMethods if defined?(ActiveRecord)
          include ActiveModel::Conversion
          include ActiveModel::Validations
        end
        if defined?(ActiveRecord) && stubs.values_at(:save, :update_attributes, :update).include?(false)
          RSpec::Mocks.allow_message(m.errors, :empty?).and_return(false)
          RSpec::Mocks.allow_message(m.errors, :blank?).and_return(false)
        end

        msingleton.__send__(:define_method, :is_a?) do |other|
          model_class.ancestors.include?(other)
        end unless stubs.key?(:is_a?)

        msingleton.__send__(:define_method, :kind_of?) do |other|
          model_class.ancestors.include?(other)
        end unless stubs.key?(:kind_of?)

        msingleton.__send__(:define_method, :instance_of?) do |other|
          other == model_class
        end unless stubs.key?(:instance_of?)

        msingleton.__send__(:define_method, :__model_class_has_column?) do |method_name|
          model_class.respond_to?(:column_names) && model_class.column_names.include?(method_name.to_s)
        end

        msingleton.__send__(:define_method, :has_attribute?) do |attr_name|
          __model_class_has_column?(attr_name)
        end unless stubs.key?(:has_attribute?)

        msingleton.__send__(:define_method, :respond_to?) do |method_name, *args|
          return true if __model_class_has_column?(method_name)

          include_private = args.first || false

          super(method_name, include_private)
        end unless stubs.key?(:respond_to?)

        msingleton.__send__(:define_method, :method_missing) do |missing_m, *a, &b|
          if respond_to?(missing_m)
            null_object? ? self : nil
          else
            super(missing_m, *a, &b)
          end
        end

        msingleton.__send__(:define_method, :class) do
          model_class
        end unless stubs.key?(:class)

        mock_param = to_param
        msingleton.__send__(:define_method, :to_s) do
          "#{model_class.name}_#{mock_param}"
        end unless stubs.key?(:to_s)
        yield m if block_given?
      end
    end
    # rubocop:enable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity

    module ActiveModelStubExtensions
      # Stubs `persisted` to return false and `id` to return nil
      def as_new_record
        RSpec::Mocks.allow_message(self, :persisted?).and_return(false)
        RSpec::Mocks.allow_message(self, :id).and_return(nil)
        self
      end

      # Returns `true` by default. Override with a stub.
      def persisted?
        true
      end
    end

    module ActiveRecordStubExtensions
      # Stubs `id` (or other primary key method) to return nil
      def as_new_record
        __send__("#{self.class.primary_key}=", nil)
        super
      end

      # Returns the opposite of `persisted?`.
      def new_record?
        !persisted?
      end

      # Raises an IllegalDataAccessException (stubbed models are not allowed to access the database)
      # @raises IllegalDataAccessException
      def connection
        raise RSpec::ActiveModel::Mocks::IllegalDataAccessException,
              "stubbed models are not allowed to access the database"
      end
    end

    # rubocop:disable Metrics/AbcSize,Metrics/MethodLength

    # Creates an instance of `Model` with `to_param` stubbed using a
    # generated value that is unique to each object. If `Model` is an
    # `ActiveRecord` model, it is prohibited from accessing the database.
    #
    # For each key in `stubs`, if the model has a matching attribute
    # (determined by `respond_to?`) it is simply assigned the submitted values.
    # If the model does not have a matching attribute, the key/value pair is
    # assigned as a stub return value using RSpec's mocking/stubbing
    # framework.
    #
    # <tt>persisted?</tt> is overridden to return the result of !id.nil?
    # This means that by default persisted? will return true. If  you want
    # the object to behave as a new record, sending it `as_new_record` will
    # set the id to nil. You can also explicitly set :id => nil, in which
    # case persisted? will return false, but using `as_new_record` makes the
    # example a bit more descriptive.
    #
    # While you can use stub_model in any example (model, view, controller,
    # helper), it is especially useful in view examples, which are
    # inherently more state-based than interaction-based.
    #
    # @example
    #
    #     stub_model(Person)
    #     stub_model(Person).as_new_record
    #     stub_model(Person, :to_param => 37)
    #     stub_model(Person) {|person| person.first_name = "David"}
    def stub_model(model_class, stubs={})
      model_class.new.tap do |m|
        m.extend ActiveModelStubExtensions
        if defined?(ActiveRecord) && model_class < ActiveRecord::Base && model_class.primary_key
          m.extend ActiveRecordStubExtensions
          primary_key = model_class.primary_key.to_sym
          stubs = { primary_key => next_id }.merge(stubs)
          stubs = { :persisted? => !!stubs[primary_key] }.merge(stubs)
        else
          stubs = { :id => next_id }.merge(stubs)
          stubs = { :persisted? => !!stubs[:id] }.merge(stubs)
        end
        stubs = { :blank? => false }.merge(stubs)

        stubs.each do |message, return_value|
          if m.respond_to?("#{message}=")
            begin
              m.__send__("#{message}=", return_value)
            rescue ActiveModel::MissingAttributeError
              RSpec::Mocks.allow_message(m, message).and_return(return_value)
            end
          else
            RSpec::Mocks.allow_message(m, message).and_return(return_value)
          end
        end

        yield m if block_given?
      end
    end
    # rubocop:enable Metrics/AbcSize,Metrics/MethodLength

    private

    # rubocop:disable Style/ClassVars
    @@model_id = 1000

    def next_id
      @@model_id += 1
    end
    # rubocop:enable Style/ClassVars
  end
end

RSpec.configuration.include RSpec::ActiveModel::Mocks::Mocks
