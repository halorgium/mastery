module Mastery
  class Authority < ActiveRecord::Base
    include CapExecution

    serialize :data, MultiJson::Serializer

    belongs_to :vat

    delegate :name, :to => :vat, :prefix => true

    def store(data)
      update_attributes!(:data => data.with_indifferent_access)
    end

    def suite
      suite_name.constantize
    end

    def cap
      suite[cap_name]
    end

    def as_json(*args)
      cap.as_json(*args).merge(:url => url).as_json(*args)
    end

    def url
      vat.url + "/authorities/#{URI.encode(name)}"
    end
  end
end
