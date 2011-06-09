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

    def url
      vat.url + "/authorities/#{URI.encode(name)}"
    end

    def authority(*keys)
      authority_url = keys.inject(data) {|hash,key| hash.fetch(key)}[:url]
      authority_for(authority_url)
    end

    def authority_for(url)
      if Rails.env == "test"
        authority_name = url.split("/").last
        Authority.where(:name => authority_name).first
      else
        RemoteAuthority.new(url)
      end
    end
  end
end
