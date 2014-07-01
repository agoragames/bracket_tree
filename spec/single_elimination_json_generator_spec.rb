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
          it 'builds seats' do
            subject.populate_first_row_matches
            subject.matches_row(0).first.should == {:seats => [1,3], :winner_to => 2, :loser_to => nil}
            subject.matches_row(0).last.should == {:seats => [29,31], :winner_to => 30, :loser_to => nil}
          end
        end
      end
    end
  end
end