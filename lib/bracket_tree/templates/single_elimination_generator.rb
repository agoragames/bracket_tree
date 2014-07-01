require 'active_support/all'

module BracketTree
  module Template
    class SingleEliminationGenerator
      attr_reader :seats, :matches, :starting_seats, :contenders

      def initialize(contenders)
        @contenders     = contenders
        @matches        = []
        @starting_seats = (1..contenders*2).select { |n| n.odd? }
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
          matches_for_row(i).times  { row << {:seats => nil, :winner_to => nil, :loser_to => nil} }
          matches << row
          i += 1
        end
      end

      def matches_row(n)
        matches[n]
      end

      def populate_matches
        populate_first_row_matches
      end

      def populate_first_row_matches
        starting_seats.in_groups_of(2).each_with_index do |arr, i|
          step ||= (arr[1] - arr[0])/2
          matches_row(0)[i][:seats] = arr
          matches_row(0)[i][:winner_to] = arr[1] - step
        end
      end
    end
  end
end