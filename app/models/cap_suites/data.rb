module CapSuites
  class Data < Mastery::CapSuite
    define :factory do
      accepts :make do |data|
        slot_authority = vat.make_authority(Data.name, :slot, data)
        read_authority = vat.make_authority(Facets.name, :messages, :inner_authority => slot_authority.id, :allowed => [:read])
        write_authority = vat.make_authority(Facets.name, :messages, :inner_authority => slot_authority.id, :allowed => [:write])

        {
          :slot_authority => slot_authority,
          :read_authority => read_authority,
          :write_authority => write_authority,
        }
      end
    end

    define :slot do
      accepts :read do ||
        data
      end

      accepts :write do |data|
        store(data)
      end
    end
  end
end
