module CapSuites
  class Eventual < Mastery::CapSuite
    define :factory do
      accepts :make do ||
        data_factory_authority = vat.make_authority(CapSuites::Data.name, :factory, {})
        metadata_result = data_factory_authority.accept(:make, :resolved => false, :data => nil)

        notify_factory_authority = vat.make_authority(CapSuites::Notify.name, :factory, {})
        notify_result = notify_factory_authority.accept(:make)

        promise_authority = vat.make_authority(Eventual.name, :promise,
                                               :metadata_authority => metadata_result[:read_authority],
                                               :registry_authority => notify_result[:registry_authority])
        resolver_authority = vat.make_authority(Eventual.name, :resolver,
                                                :metadata_authority => metadata_result[:write_authority],
                                                :subject_authority => notify_result[:subject_authority])

        {:promise_authority => promise_authority, :resolver_authority => resolver_authority}
      end
    end

    define :promise do
      accepts :register do |target_authority|
        authority(:registry_authority).accept(:register, target_authority)
      end

      as_hash do
        metadata = authority(:metadata_authority).accept(:read)
        metadata.slice(:resolved, :data)
      end
    end

    define :resolver do
      accepts :resolve_with do |data|
        authority(:metadata_authority).accept(:write, :resolved => true, :data => data)
        authority(:subject_authority).accept(:notify, :data => data)
        true
      end
    end
  end
end
