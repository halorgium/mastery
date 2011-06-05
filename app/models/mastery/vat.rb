module Mastery
  class Vat < ActiveRecord::Base
    has_many :authorities

    def self.make(primary_suite_name, primary_cap_name, data)
      vat = create!(:name => random_base32(16))
      vat.make_authority(primary_suite_name, primary_cap_name, data)
    end

    def make_authority(suite_name, cap_name, data)
      authorities.create!(:name => random_base32(16), :suite_name => suite_name, :cap_name => cap_name, :data => data)
    end

    private

    def self.random_base32(size)
      bytes = ActiveSupport::SecureRandom.random_bytes(size * 2)
      base32 = Base32.encode(bytes)
      base32[0, size]
    end

    def random_base32(size)
      self.class.random_base32(size)
    end
  end
end
