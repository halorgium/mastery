module Mastery
  class Cap
    def initialize(suite_name, name)
      @suite_name = suite_name
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

    def full_name
      "#{@suite_name}.#{@name}"
    end

    def as_json(*args)
      as_hash.merge(:class => full_name).as_json(*args)
    end

    def as_hash
      {}
    end
  end
end
