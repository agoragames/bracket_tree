require 'active_support/all'
require 'json'

module BracketTree
  module Template
    class SingleEliminationGenerator
      attr_reader :seats, :matches, :starting_seats, :slots

      def initialize(slots)
        @slots          = slots
        @matches        = []
        @seats          = []
        @starting_seats = (1..slots*2).select { |n| n.odd? }
      end

      def build
        build_matches
        populate_matches
        populate_seats
      end

      def to_hash
        {
          :matches        => matches.flatten,
          :seats          => seats,
          :starting_seats => starting_seats
        }
      end

      def to_json
        to_hash.to_json
      end

      def matches_for_row(n)
        if n == 1
          slots / 2
        else
          matches_for_row(n - 1) / 2
        end
      end

      def build_matches
        if matches.empty?
          i = 1
          while matches_for_row(i) > 0
            row = []
            matches_for_row(i).times  do
              row << {:seats => nil, :winner_to => nil, :loser_to => nil}
            end
            matches << row
            i += 1
          end
        end
      end

      def matches_row(n)
        matches[n]
      end

      def populate_matches
        step = nil
        populate_first_row_matches
        matches.each_with_index do |row, level|
          next_row_groups = row.inject Array.new do |arr, match|
            arr << match[:winner_to]
          end.in_groups_of(2)
          next_matches = matches[level+1]
          if next_matches
            next_matches.each_with_index do |match, i|
              match[:seats] = next_row_groups[i]
              if i.zero?
                step = (match[:seats][1] - match[:seats][0]) / 2
              end
              match[:winner_to] = match[:seats][1] - step
            end
          end
        end
        matches.last.last[:winner_to] = nil
      end

      def populate_first_row_matches
        starting_seats.in_groups_of(2).each_with_index do |arr, i|
          step ||= (arr[1] - arr[0])/2
          matches_row(0)[i][:seats] = arr
          matches_row(0)[i][:winner_to] = arr[1] - step
        end
      end

      def populate_seats
        matches_seats = matches.map {|arr| arr.map {|a| a[:seats]}}
        ordered_seats = slots < 32 ? matches_seats.reverse.map {|a| a.reverse} : matches_seats.reverse
        flat_seats    = ordered_seats.flatten
        first_seat    = flat_seats.first*2
        all_seats     = flat_seats.unshift first_seat
        @seats        = all_seats.map {|n| {:position => n} }
      end
    end
  end
end