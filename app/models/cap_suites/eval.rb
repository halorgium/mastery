module CapSuites
  class Eval < Mastery::CapSuite
    define :factory do
      accepts :make do |code|
        authority = vat.make_authority(Eval.name, :runner, :code => code)
        {:runner_authority => authority}
      end
    end

    define :runner do
      accepts :run do |*args|
        instance_eval(data[:code])
      end
    end
  end
end
