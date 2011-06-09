module CapSuites
  class Revoke < Mastery::CapSuite
    define :factory do
      accepts :make do |inner_authority|
        data_factory_authority = vat.make_authority(CapSuites::Data.name, :factory, {})
        metadata_result = data_factory_authority.accept(:make, :inner_authority => inner_authority)

        proxy_authority = vat.make_authority(Revoke.name, :proxy, :metadata_authority => metadata_result[:read_authority])
        revoker_authority = vat.make_authority(Revoke.name, :revoker, :metadata_authority => metadata_result[:slot_authority])

        {:proxy_authority => proxy_authority, :revoker_authority => revoker_authority}
      end
    end

    define :proxy do
      proxies do |message_name,args|
        metadata = authority(:metadata_authority).accept(:read)
        if authority = metadata[:inner_authority]
          authority_for(authority).accept(message_name, *args)
        else
          raise "Invalid message"
        end
      end
    end

    define :revoker do
      accepts :revoke do ||
        authority(:metadata_authority).accept(:write, {})
      end
    end
  end
end
