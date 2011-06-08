module Mastery
  class Authority < ActiveRecord::Base
    serialize :data, MultiJson::Serializer

    belongs_to :vat

    delegate :name, :to => :vat, :prefix => true

    def suite
      suite_name.constantize
    end

    def cap
      suite[cap_name]
    end

    def accept(message_name, *args)
      cap.accept(message_name, *args)
    end
  end
end
