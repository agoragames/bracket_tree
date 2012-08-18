require 'spec_helper'

describe BracketTree::PositionalRelation do
  let(:bracket) { BracketTree::Bracket::DoubleElimination.by_size(4) }
  let(:relation) { BracketTree::PositionalRelation.new(bracket) }
  describe '#winners' do
    it 'should set the side to left' do
      relation.winners
      relation.instance_variable_get(:@side).should == :left
    end

    it 'should return the same relation that called the method' do
      r = relation.winners
      r.should be relation
    end
  end

  describe '#losers' do
    it 'should set the side to right' do
      relation.losers
      relation.instance_variable_get(:@side).should == :right
    end

    it 'should return the same relation that called the method' do
      r = relation.losers
      r.should be relation
    end
  end

  describe '#round' do
    it 'should set the round to the passed parameter' do
      relation.round(4)
      relation.instance_variable_get(:@round).should == 4
    end

    it 'should return the same relation that called the method' do
      r = relation.round(4)
      r.should be relation
    end
  end

  describe '#seat' do
    it 'should return the Node that corresponds to the given seat number' do
      node = relation.winners.round(1).seat(3)
      node.should be_instance_of BracketTree::Node
    end

    it 'should return the current number to the given seat number' do
      node = relation.winners.round(1).seat(3)
      node.position.should == 5
    end

    it 'should return nil if the seat exceeds parameters' do
      node = relation.winners.round(1).seat(9)
      node.should be_nil
    end
  end

  describe '#all' do
    it 'should return an Array of Node objects' do
      nodes = relation.winners.round(1).all
      nodes.should be_instance_of(Array)
      nodes.should have(4).nodes
      nodes.map(&:class).uniq.first.should == BracketTree::Node
    end

    it 'should pull all sides of tree if a side is not picked' do
      nodes = relation.round(1).all
      nodes.should have(6).nodes
    end

    it 'should pull all rounds of a side if a round is not picked' do
      nodes = relation.winners.all
      nodes.should have(7).nodes
    end

    it 'should pull every node if neither round nor side is picked' do
      nodes = relation.all
      nodes.should have(13).nodes
    end
  end

  describe '#first' do
    it 'should return the first seat of the applicable nodes' do
      node = relation.round(1).first
      node.should be_instance_of(BracketTree::Node)
      node.position.should == 1
    end
  end

  describe '#last' do
    it 'should return the last seat of the applicable nodes' do
      node = relation.round(1).last
      node.should be_instance_of(BracketTree::Node)
      node.position.should == 13
    end
  end
end
