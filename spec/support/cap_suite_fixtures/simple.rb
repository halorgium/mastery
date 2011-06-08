module CapSuiteFixtures
  class Simple < Mastery::CapSuite
    define :mirror do
      accepts :echo do |message|
        message
      end

      accepts :reverse_echo do |message|
        message.reverse
      end
    end
  end
end
