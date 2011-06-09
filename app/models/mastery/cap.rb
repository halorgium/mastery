module Mastery
  class Cap
    def initialize(suite_name, name)
      @suite_name = suite_name
      @name = name
      @messages = {}
    end
    attr_reader :name, :messages, :proxy, :hash_block

    def proxies(&block)
      @proxy = block
    end

    def as_hash(&block)
      @hash_block = block
    end

    def accepts(message_name, &block)
      @messages[message_name.to_s] = block
    end

    def [](message_name)
      @messages[message_name.to_s]
    end

    def full_name
      "#{@suite_name}.#{@name}"
    end
  end
end
