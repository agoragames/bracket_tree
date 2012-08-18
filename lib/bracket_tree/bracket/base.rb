module BracketTree
  module Bracket
    # Basic bracketing functionality.  If you wish to create a custom bracket type,
    # inherit from this class to provide easy access to bracketing.
    #
    # Example:
    #   class MLGDouble < BracketTree::Bracket::Base
    #     template BracketTree::Template::DoubleElimination
    #   end
    #   
    #   bracket = MLGDouble.by_size 8
    #
    # This creates a bracket based on the standard double elimination template class.
    # The template parameter can be any class that inherits from BracketTree::Template::Base,
    # though.
    #
    #  class MLGDoubleTemplate < BracketTree::Template::Base
    #    def self.location
    #      File.join File.dirname(__FILE__), 'templates', 'mlg_double'
    #    end
    #  end
    #
    #  class MLGDouble < BracketTree::Bracket::Base
    #    template MLGDoubleTemplate
    #  end
    class Base
      class NoTemplateError < Exception ; end

      class << self
        def by_size size, options = {}
          generate_from_template @template, size
        end

        def template class_name
          @template = class_name
        end

        # Generates a blank bracket object from the passed Template class for the 
        # passed size
        #
        # @param BracketTree::Template::Base template - the Template the bracket is
        #   based on
        # @param Fixnum size - bracket size
        # @return BracketTree::Bracket::Base bracket - a blank bracket with hash placeholders
        def generate_from_template template, size
          template = template.by_size size
          bracket = new(matches: template.matches, seed_order: template.seed_order)

          template.seats.each do |position|
            bracket.add position, {}
          end

          bracket
        end
      end

      include Enumerable
      attr_accessor :root, :seed_order, :matches, :insertion_order, :depth

      def initialize options = {}
        @insertion_order = []
        @matches = []
        @depth = {
          total: 0,
          left: 0,
          right: 0
        }

        if options[:matches]
          options[:matches].each do |m|
            @matches << Match.new(m)
          end
        end

        @seed_order = options[:seed_order] if options[:seed_order]
      end

      # Adds a Node at the given position, setting the data as the payload. Maps to
      # binary tree under the hood.  The `data` can be any serializable object.
      #
      # @param Fixnum position - Seat position to add
      # @param Object data - the player object to store in the Seat position
      def add position, data
        node = Node.new position, data
        @insertion_order << position

        if @root.nil?
          @root = node
          @depth[:total] = 1
          @depth[:left] = 1
          @depth[:right] = 1
        else
          current = @root
          current_depth = 2
          loop do
            if node.position < current.position
              if current.left.nil?
                node.depth = current_depth
                current.left = node

                depth_check current_depth, node.position
                break
              else
                current = current.left
                current_depth += 1
              end
            elsif node.position > current.position
              if current.right.nil?
                node.depth = current_depth
                current.right = node

                depth_check current_depth, node.position
                break
              else
                current = current.right
                current_depth += 1
              end
            else
              break
            end
          end
        end
      end

      def depth_check depth, position
        @depth[:total] = [depth, @depth[:total]].max
        @depth[:left]  = [depth, @depth[:left] ].max if position < @root.position
        @depth[:right] = [depth, @depth[:right]].max if position > @root.position
      end

      # Replaces the data at a given node position with new payload. This is useful
      # for updating bracket data, replacing placeholders with actual data, seeding,
      # etc..
      #
      # @param [Fixnum] position - the node position to replace
      # @param payload - the new payload object to replace
      def replace position, payload
        node = at position
        if node
          node.payload = payload
          true
        else
          nil
        end
      end

      # Seeds bracket based on `seed_order` value of bracket.  Provide an iterator
      # with players that will be inserted in the appropriate location.  Will raise a
      # SeedLimitExceededError if too many players are sent, and a NoSeedOrderError if
      # the `seed_order` attribute is nil
      #
      # @param [Enumerable] players - players to be seeded
      def seed players
        if @seed_order.nil?
          raise NoSeedOrderError, 'Bracket does not have a seed order.'
        elsif players.size > @seed_order.size
          raise SeedLimitExceededError, 'cannot seed more players than seed order list.'
        else
          @seed_order.each do |position|
            replace position, players.shift
          end
        end
      end

      def winner
        @root.payload
      end

      def each(&block)
        in_order(@root, block)
      end

      def to_h
        @root.to_h
      end

      # Array of Seats mapping to the individual positions of the bracket tree. The
      # order of the nodes is important, as insertion in this order maintains the
      # binary tree
      #
      # @return Array seats
      def seats
        entries.sort_by { |node| @insertion_order.index(node.position) }
      end

      alias_method :to_a, :seats

      def at position
        find { |n| n.position == position }
      end

      alias_method :size, :count

      # Progresses the bracket by using the stored `matches` to copy data to the winning
      # and losing seats.  This facilitates match progression without manually
      # manipulating bracket positions
      #
      # @param Fixnum seat - winning seat position
      # @return Boolean result - result of progression
      def match_winner seat
        match = @matches.find { |m| m.include? seat }

        if match
          losing_seat = match.seats.find { |s| s != seat }

          if match.winner_to
            replace match.winner_to, at(seat).payload
          end

          if match.loser_to
            replace match.loser_to, at(losing_seat).payload
          end

          return true
        else
          return false
        end
      end

      # Inverse of `match_winner`, progresses the bracket based on seat. See `match_winner`
      # for more details
      #
      # @param Fixnum seat - losing seat position
      # @return Boolean result - result of progression
      def match_loser seat
        match = @matches.find { |m| m.include? seat }
        
        if match
          winning_seat = match.seats.find { |s| s != seat }
          match_winner winning_seat
        else
          return false
        end
      end

      def in_order(node, block)
        if node
          in_order(node.left, block) unless node.left.nil?

          block.call(node)

          in_order(node.right, block) unless node.right.nil?
        end
      end

      def top_down(node, &block)
        if node
          block.call(node)

          top_down(node.left, &block) unless node.left.nil?
          top_down(node.right, &block) unless node.right.nil?
        end
      end
    end
  end
end
