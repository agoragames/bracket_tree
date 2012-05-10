module BracketTree
  class Node
    attr_accessor :left, :right, :position, :payload

    def initialize position, payload = nil
      @position = position
      @payload = payload
    end

    def method_missing(sym, *args, &block)
      @payload.send sym, *args, &block
  end
  end
end
