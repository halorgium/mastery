module CapSuites
  class Facets < Mastery::CapSuite
    define :factory do
      accepts :make do |allowed,inner_authority|
        authority = vat.make_authority(Facets.name, :proxy, :allowed => allowed, :inner_authority => inner_authority)
        {:proxy_authority => authority}
      end
    end

    define :proxy do
      proxies do |message_name,args|
        if data[:allowed].include?(message_name)
          authority_for(data[:inner_authority]).accept(message_name, *args)
        else
          raise "Invalid message"
        end
      end
    end
  end
end
