require 'active_support/json/encoding'

class Object
  def as_json(options = nil)
    if respond_to?(:to_hash)
      to_hash
    else
      {}
    end
  end
end
