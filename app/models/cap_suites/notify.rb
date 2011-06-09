module CapSuites
  class Notify < Mastery::CapSuite
    define :factory do
      accepts :make do ||
        data_factory_authority = vat.make_authority(CapSuites::Data.name, :factory, {})
        metadata_result = data_factory_authority.accept(:make, :authorities => [])

        observer_authority = vat.make_authority(Notify.name, :observer,
                                                :observers_authority => metadata_result[:slot_authority])
        observable_authority = vat.make_authority(Notify.name, :observable,
                                                  :observers_authority => metadata_result[:read_authority])

        {:observer_authority => observer_authority, :observable_authority => observable_authority}
      end
    end

    define :observer do
      accepts :watch do |authority|
        observers_authority = authority(:observers_authority)
        data = observers_authority.accept(:read)
        data[:authorities] << authority
        observers_authority.accept(:write, data)
      end
    end

    define :observable do
      accepts :notify do |result|
        observers_authority = authority(:observers_authority)
        data = observers_authority.accept(:read)
        data[:authorities].each do |authority_url|
          begin
            authority_for(authority_url).accept(:notify, result)
          rescue => e
            Rails.logger.error("Failed to notify #{authority_url}: #{e.class}: #{e.message}")
          end
        end
        true
      end
    end
  end
end
