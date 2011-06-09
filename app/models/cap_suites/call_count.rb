module CapSuites
  class CallCount < Mastery::CapSuite
    define :factory do
      accepts :make do |call_count,inner_authority|
        authority = vat.make_authority(CallCount.name, :proxy, :call_count => call_count, :inner_authority => inner_authority)
        {:proxy_authority => authority}
      end
    end

    define :proxy do
      proxies do |message_name,args|
        if data[:call_count] > 0
          data[:call_count] -= 1
          store(data)
          authority_for(data[:inner_authority]).accept(message_name, *args)
        else
          raise "Invalid message"
        end
      end
    end
  end
end

