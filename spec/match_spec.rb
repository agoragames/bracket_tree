require 'spec_helper'

describe BracketTree::Match do
  it 'should log the seats if passed' do
    match = BracketTree::Match.new seats: [1,2]
    match.seats.should == [1,2]
  end

  it 'should log the winner_to if passed' do
    match = BracketTree::Match.new winner_to: 1
    match.winner_to.should == 1
  end

  it 'should log the loser_to if passed' do
    match = BracketTree::Match.new loser_to: 1
    match.loser_to.should == 1
  end

  describe '#include?' do
    it 'should return true if seat is part of Match' do
      match = BracketTree::Match.new seats: [1,2]
      match.include?(1).should be_true
    end

    it 'should return false if seats is not part of Match' do
      match = BracketTree::Match.new seats: [1,2]
      match.include?(3).should be_false
    end
  end
end
