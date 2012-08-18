require 'forwardable'

module BracketTree
  # PositionalRelation
  #
  # This class is a relational object used for constructing tree traversal when
  # you do not know the exact position value that you are looking for. It uses
  # two types of methods: relation condition methods and relation access methods.
  #
  # Relation Condition Methods
  #
  # Relation condition methods take the original `PositionalRelation` object and
  # add conditions, returning the original object for easy chaining of relation
  # conditions.  Actual traversal does not happen with these methods.
  #
  # @example
  #   bracket = BracketTree::Bracket::DoubleElimination.by_size(4)
  #   relation = BracketTree::PositionalRelation.new(bracket) # => <BracketTree::PositionalRelation:0x007fa9431e1060>
  #   relation.winners # => <BracketTree::PositionalRelation:0x007fa9431e1060>
  #   relation.round(4) # => <BracketTree::PositionalRelation:0x007fa9431e1060>
  #
  # Relation conditions can be chained to create very specific or very broad
  # options.  Once you call a Relation Access Method, it will build based on the
  # chain.
  #
  # @example Complex chaining of relations
  #   bracket = BracketTree::Bracket::DoubleElimination.by_size(4)
  #   relation = BracketTree::PositionalRelation.new(bracket)
  #   relation.winners.round(4).seat(3) # => <BracketTree::Node:0x01e37>
  #
  # Typically you will not directly instance BracketTree::RelationalPosition due
  # to the need to pass in a bracket. Instead, bracket objects have access to these
  # methods directly, and will return a BracketTree::PositionalRelation object.
  #
  # Relation Access Methods
  #
  # Relation access methods take the complete set of relation conditions and uses
  # them as instructions for traversing the tree to collect the Node(s) requested.
  #
  # @example
  #   bracket = BracketTree::Bracket::DoubleElimination.by_size(4)
  #   bracket.winners.round(4).first # => <BracketTree::Node:0x007fa9271e73e0>
  class PositionalRelation
    attr_reader :bracket

    def initialize bracket
      @bracket = bracket
    end

    # Retrieves the first seat based on the stored relation conditions
    #
    # @return [BracketTree::Node, nil]
    def first
      seats = all
      seats.first
    end

    # Retrieves the last seat based on the stored relation conditions
    #
    # @return [BracketTree::Node, nil]
    def last
      seats = all
      seats.last
    end

    # Retrieves all seats based on the stored relation conditions
    #
    # @return [Array<BracketTree::Node>]
    def all
      if @side
        if @round
          seats = by_round @round, @side
        else
          side_root = @bracket.root.send(@side)
          seats = []

          @bracket.top_down(side_root) do |node|
            seats << node
          end
        end
      else
        if @round
          seats = by_round(@round, :left) + by_round(@round, :right)
        else
          seats = []
          @bracket.top_down(@bracket.root) do |node|
            seats << node
          end
        end
      end

      seats
    end

    # Retrieves the `number`-th seat from the given relation conditions
    #
    # @param [Fixnum] seat number
    # @return [BracketTree::Node, nil] the seat requested
    def seat number
      seats = all

      seats[number-1]
    end

    # Retrieves an Array of Nodes for a given round on a given side
    #
    # @param [Fixnum] round to pull
    # @param [Fixnum] side of the tree to pull from
    # @return [Array] array of Nodes from the round
    def by_round round, side
      depth = @bracket.depth[side] - (round - 1)
      seats = []

      side_root = @bracket.root.send(side)
      @bracket.top_down(side_root) do |node|
        if node.depth == depth
          seats << node
        end
      end

      seats
    end

    # Adds relation condition for left half of the bracket. This is used in
    # double-elimination brackets primarily.
    #
    # @return [BracketTree::PositionalRelation]
    def winners
      @side = :left
      return self
    end

    # Adds relation condition for right half of the bracket. This is used in
    # double-elimination brackets primarily.
    #
    # @return [BracketTree::PositionalRelation]
    def losers
      @side = :right
      return self
    end

    # Adds relation condition for a given round. This is represented by translating
    # the total depth of the tree minus the number parameter.
    #
    # @param [Fixnum] round number
    # @return [BracketTree::PositionalRelation]
    def round number
      @round = number
      return self
    end
  end

  # This module provides the delegation used for PositionalRelation. Including this
  # module results in brackets gaining the understanding of the positional relation
  # traversal system.
  #
  # @example
  #   class CrazyBracket < BracketTree::Bracket::Base
  #     include BracketTree::PositionalRelation
  #   end
  #
  #   bracket = CrazyBracket.new
  #   bracket.winners.all # => []
  module PositionalRelationDelegators
    extend Forwardable

    def relation
      BracketTree::PositionalRelation.new(self)
    end

    def_delegators :relation, :winners, :losers, :round, :all, :first, :last, :seat
  end
end
