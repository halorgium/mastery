module Mastery
  class Authority < ActiveRecord::Base
    serialize :data, MultiJson::Serializer

    belongs_to :vat

    delegate :name, :to => :vat, :prefix => true

    def klass
      klass_name.constantize
    end
  end
end
