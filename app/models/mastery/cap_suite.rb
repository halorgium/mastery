module Mastery
  class CapSuite
    def self.define(name, &block)
      name = name.to_s
      if caps[name]
        raise "Already defined #{name.inspect}"
      end
      cap= Cap.new(name)
      cap.instance_eval(&block)
      caps[name] = cap
    end

    def self.[](name)
      caps.fetch(name.to_s)
    end

    def self.cap_names
      caps.keys
    end

    private

    def self.caps
      @caps ||= {}
    end
  end
end
