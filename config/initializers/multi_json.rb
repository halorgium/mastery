MultiJson.engine = :yajl

module MultiJson
  class Serializer
    def self.load(json)
      if json.nil?
        json = "{}"
      end
      object = MultiJson.decode(json)
      assert_hash(object)
      object
    end

    def self.dump(object)
      assert_hash(object)
      MultiJson.encode(object)
    end

    def self.assert_hash(object)
      unless object.is_a?(Hash)
        raise "Not a Hash"
      end
    end
  end
end
