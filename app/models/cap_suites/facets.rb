module CapSuites
  class Facets < Mastery::CapSuite
    define :messages do
      proxies do |message_name,args|
        if data[:allowed].include?(message_name)
          Mastery::Authority.find(data[:inner_authority]).accept(message_name, *args)
        else
          raise "Invalid message"
        end
      end
    end
  end
end
