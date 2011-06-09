module CapSuites
  class Notify < Mastery::CapSuite
    define :factory do
      accepts :make do ||
        data_factory_authority = vat.make_authority(CapSuites::Data.name, :factory, {})
        metadata_result = data_factory_authority.accept(:make, :authorities => [])

        registry_authority = vat.make_authority(Notify.name, :registry,
                                                :observers_authority => metadata_result[:slot_authority])
        subject_authority = vat.make_authority(Notify.name, :subject,
                                               :observers_authority => metadata_result[:read_authority])

        {:registry_authority => registry_authority, :subject_authority => subject_authority}
      end
    end

    define :registry do
      accepts :register do |authority|
        observers_authority = authority(:observers_authority)
        data = observers_authority.accept(:read)
        data[:authorities] << authority
        observers_authority.accept(:write, data)
      end
    end

    define :subject do
      accepts :notify do |result|
        observers_authority = authority(:observers_authority)
        data = observers_authority.accept(:read)
        data[:authorities].each do |authority|
          begin
            authority_for(authority[:url]).accept(:notify, result)
          rescue => e
            Rails.logger.error("Failed to notify #{authority.inspect}: #{e.class}: #{e.message}")
          end
        end
        true
      end
    end

    define :observer do
      accepts :notify do |result|
        data[:results] ||= []
        data[:results] << result
        store(data)
      end

      as_hash do
        data.slice(:results)
      end
    end
  end
end
