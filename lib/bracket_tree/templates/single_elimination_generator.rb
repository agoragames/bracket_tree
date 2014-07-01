module BracketTree
  module Template
    class SingleEliminationGenerator
      attr_reader :seats, :matches, :starting_seats, :contenders

      def initialize(contenders)
        @contenders = contenders
        @matches    = []
      end

      def matches_for_row(n)
        if n == 1
          contenders / 2
        else
          matches_for_row(n - 1) / 2
        end
      end

      def build_matches
        i = 1
        while matches_for_row(i) > 0
          row = []
          matches_for_row(i).times  { row << {} }
          matches << row
          i += 1
        end
      end

      def matches_row(n)
        matches[n]
      end
    end
  end
end