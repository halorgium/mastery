module Mastery
  class Cap
    def initialize(name)
      @name = name
      @messages = {}
    end
    attr_reader :name, :messages

    def accepts(message_name, &block)
      @messages[message_name] = block
    end

    def accept(message_name, *args)
      if block = @messages[message_name]
        if args.size == block.arity
          block[*args]
        else
          raise "Invalid arity"
        end
      else
        raise "Invalid message"
      end
    end
  end
end
