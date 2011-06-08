module Mastery
  class Authority < ActiveRecord::Base
    include CapExecution

    serialize :data, MultiJson::Serializer

    belongs_to :vat

    delegate :name, :to => :vat, :prefix => true

    def suite
      suite_name.constantize
    end

    def cap
      suite[cap_name]
    end

    def as_json(*args)
      cap.as_json(*args)
    end
  end
end
