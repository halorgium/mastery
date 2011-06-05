module Mastery
  class Vat < ActiveRecord::Base
    has_many :authorities
  end
end
