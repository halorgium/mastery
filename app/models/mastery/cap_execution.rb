module Mastery
  module CapExecution
    def accept(message_name, *args)
      if proxy = cap.proxy
        (class << self; self; end).send(:define_method, :__accept__, &proxy)
        __accept__(message_name.to_s, args)
      elsif block = cap[message_name]
        arity_range = if block.arity < 0
          -(block.arity + 1)..(1.0/0.0)
        else
          [block.arity]
        end

        if arity_range.include?(args.size)
          (class << self; self; end).send(:define_method, :__accept__, &block)
          __accept__(*args)
        else
          raise "Invalid arity"
        end
      else
        raise "Invalid message"
      end
    end

    def as_hash
      if block = cap.hash_block
        (class << self; self; end).send(:define_method, :__as_hash__, &block)
        __as_hash__
      else
        {}
      end
    end

    def as_json(*args)
      as_hash.merge(:class => cap.full_name, :url => url).as_json(*args)
    end
  end
end
