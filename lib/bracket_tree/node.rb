module BracketTree
  class Node
    attr_accessor :left, :right, :position, :payload, :depth

    def initialize position, payload = nil
      @position = position
      @payload = payload
    end

    def method_missing(sym, *args, &block)
      @payload.send sym, *args, &block
    end

    def to_h
      {
        position: @position,
        payload: @payload,
        left: @left ? @left.to_h : nil,
        right: @right ? @right.to_h : nil
      }
    end
  end
end
