module Mastery
  class RemoteAuthority
    def initialize(url)
      @url = url
    end
    attr_reader :url

    def accept(message, *args)
      data = {
        :message => message,
        :args => args,
      }
      response = Curl::Easy.http_put(@url, data.to_json) do |c|
        c.headers["Accept"] = "application/json"
        c.headers["Content-Type"] = "application/json"
      end

      json = response.body_str
      body = JSON.parse(json).with_indifferent_access

      case response.response_code
      when 200
        body[:result]
      else
        raise "unknown response"
      end
    end

    def as_json(*args)
      response = Curl::Easy.http_get(@url)
      json = response.body_str
      JSON.parse(json).as_json(*args)
    end
  end
end
