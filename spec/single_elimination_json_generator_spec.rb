require 'pry'
require 'spec_helper'

module BracketTree
  module Template
    describe SingleEliminationGenerator do
      context 'with 16 contenders' do
        subject { SingleEliminationGenerator.new(16) }

        before { subject.build_matches }

        it 'builds 15 matches' do
          subject.matches.flatten.size.should == 15
        end

        it 'has 16 starting seats' do
          subject.starting_seats.size.should == 16
        end

        it 'has 8 matches in the first row' do
          subject.matches_row(0).size.should == 8
        end

        describe '#matches_for_row' do
          it 'is in sequence 8,4,2,0' do
            subject.matches_for_row(1).should == 8
            subject.matches_for_row(2).should == 4
            subject.matches_for_row(3).should == 2
            subject.matches_for_row(4).should == 1
          end
        end

        describe '#populate_first_row_matches' do
          before { subject.populate_first_row_matches }

          it 'builds first match with expected values' do
            first_match = {:seats => [1,3],   :winner_to => 2,  :loser_to => nil}
            subject.matches_row(0).first.should == first_match
          end

          it 'builds last match with expected values' do
            last_match  = {:seats => [29,31], :winner_to => 30, :loser_to => nil}
            subject.matches_row(0).last.should  == last_match
          end
        end

        describe '#populate_matches' do
          before { subject.populate_matches }

          it 'builds ninth match with expected values' do
            ninth_match = {:seats => [2,6], :winner_to => 4, :loser_to => nil}
            subject.matches_row(1).first.should == ninth_match
          end

          it 'builds last match with expected values' do
            last_match = {:seats => [8,24], :winner_to => nil, :loser_to => nil}
            subject.matches.last.first.should == last_match
          end
        end

        describe '#populate_seats' do
          it 'builds seats as expected' do
            subject.populate_matches
            subject.populate_seats
            subject.seats[1].should == {:position => 8}
          end
        end

        describe '.to_json' do
          it 'builds expected json 8' do
            subject = SingleEliminationGenerator.new(8)
            hash = JSON.parse File.read(File.expand_path '../../lib/bracket_tree/templates/single_elimination/8.json', __FILE__), :symbolize_names => true
            subject.build
            subject.to_hash.should == hash.symbolize_keys
          end

          it 'builds expected json 16' do
            subject = SingleEliminationGenerator.new(16)
            hash = JSON.parse File.read(File.expand_path '../../lib/bracket_tree/templates/single_elimination/16.json', __FILE__), :symbolize_names => true
            subject.build
            subject.to_hash.should == hash.symbolize_keys
          end
        end
      end
    end
  end
end