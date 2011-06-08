module Mastery
  module CapExecution
    def accept(message_name, *args)
      if block = cap[message_name]
        if args.size == block.arity
          (class << self; self; end).send(:define_method, :__accept__, &block)
          __accept__(*args)
        else
          raise "Invalid arity"
        end
      else
        raise "Invalid message"
      end
    end
  end
end
