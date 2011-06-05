MultiJson.engine = :yajl

module MultiJson
  class Serializer
    def self.load(json)
      if json.nil?
        json = "{}"
      end
      MultiJson.decode(json)
    end

    def self.dump(object)
      MultiJson.encode(object)
    end
  end
end
