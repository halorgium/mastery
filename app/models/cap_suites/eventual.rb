module CapSuites
  class Eventual < Mastery::CapSuite
    define :factory do
      accepts :make do ||
        data_factory_authority = vat.make_authority(Data.name, :factory, {})
        metadata_result = data_factory_authority.accept(:make, :resolved => false, :data => nil)

        promise_authority = vat.make_authority(Eventual.name, :promise,
                                               :metadata_authority => metadata_result[:read_authority])
        resolver_authority = vat.make_authority(Eventual.name, :resolver,
                                               :metadata_authority => metadata_result[:write_authority])

        {:promise_authority => promise_authority, :resolver_authority => resolver_authority}
      end
    end

    define :promise do
      as_hash do
        metadata = authority(:metadata_authority).accept(:read)
        metadata.slice(:resolved, :data)
      end
    end

    define :resolver do
      accepts :resolve_with do |data|
        authority(:metadata_authority).accept(:write, :resolved => true, :data => data)
        true
      end
    end
  end
end
