module Mastery
  class Authority < ActiveRecord::Base
    serialize :data, MultiJson::Serializer

    belongs_to :vat
  end
end
