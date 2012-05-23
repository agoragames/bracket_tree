module BracketTree
  # Contains the logic for common template formats. Holds match progression as well as seat order to generate the correct bracket tree.
  module Template
    class Base
      class << self
        # Reads stored JSON files to generate a Template
        #
        # @param [Fixnum] size - player count
        # return [nil, BracketTree::Template] template - the resulting bracket template
        def by_size size
          filename = File.join location, "#{size}.json"

          if File.exists? filename
            from_json JSON.parse File.read filename
          else
            return nil
          end
        end

        # Generates Template from JSON
        #
        # @param [String] json - the bracket template in its standard data specification
        # @return [BracketTree::Template]
        def from_json json
          template = new
          if json['seats']
            template.seats = json['seats'].map { |s| s['position'] }
          end

          if json['startingSeats']
            template.starting_seats = json['startingSeats']
          end

          if json['nodes']
            template.nodes = json['nodes']
          end

          template
        end

        # Folder location of the template JSON files. Abstract method
        # @return [String] location - the folder name of the JSON files
        def location
          raise NotImplementedError, 'Abstract method, please define `location` in subclass.'
        end
      end

      attr_accessor :seats, :starting_seats, :nodes

      def initialize
        @seats = []
        @starting_seats = []
        @nodes = []
      end

      # Generates a Bracket object with placeholder empty hashes for each Seat in the
      # Template
      #
      # @return [BracketTree::Bracket] bracket
      def generate_blank_bracket
        bracket = Bracket.new

        @seats.each do |position|
          bracket.add position, {}
        end

        bracket.seed_order = @starting_seats

        bracket
      end

      # Returns hash representation of the Template
      #
      # @return [Hash] template
      def to_h
        {
          'seats' => @seats.map { |s| { 'position' => s } },
          'startingSeats' => @starting_seats,
          'nodes' => @nodes
        }
      end
    end
  end
end
