module CapSuites
  class DuoAuth < Mastery::CapSuite
    define :meta_factory do
      accepts :make do |ikey,skey,host|
        authority = vat.make_authority(DuoAuth.name, :factory, :ikey => ikey, :skey => skey, :host => host)
        {:factory_authority => authority}
      end
    end

    define :factory do
      accepts :make do |username,target_authority,message,args|
        akey = SecureRandom.hex(40)
        new_data = {
          :akey => akey,
          :username => username,
          :target_authority => target_authority,
          :message => message,
          :args => args
        }
        authority = vat.make_authority(DuoAuth.name, :approver, data.merge(new_data))
        {:approver_authority => authority}
      end
    end

    define :approver do
      accepts :request do ||
        sig_request = Duo.sign_request(data[:ikey], data[:skey], data[:akey], data[:username])
        {:host => data[:host], :sig_request => sig_request}
      end

      accepts :verify do |sig_response|
        if username = Duo.verify_response(data[:ikey], data[:skey], data[:akey], sig_response)
          if username == data[:username]
            authority_for(data[:target_authority]).accept(data[:message])
          else
            raise "Username mismatch"
          end
        else
          raise "Verify fail"
        end
      end
    end
  end
end
