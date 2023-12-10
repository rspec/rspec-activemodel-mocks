# frozen_string_literal: true
class NullObject
  private

  def method_missing(method, *args, &blk)
  end
end
