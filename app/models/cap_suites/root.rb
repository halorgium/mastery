module CapSuites
  class Root < Mastery::CapSuite
    define :factory do
      accepts :make do |primary_suite_name,primary_cap_name,data|
        authority = Mastery::Vat.make(primary_suite_name, primary_cap_name, data)
        {:root_authority => authority}
      end
    end
  end
end
