# frozen_string_literal: true
Given(/a (\w+) model/) do |model_class_name|
  puts eval(model_class_name)
end
