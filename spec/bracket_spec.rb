require 'spec_helper'

describe BracketTree::Bracket::Base do
  let(:bracket) { BracketTree::Bracket::Base.new }

  describe '#initialize' do
    it 'should create an array of Match objects if matches are passed' do
      matches = [
        { seats: [1,3], winner_to: 2, loser_to: nil },
        { seats: [5,7], winner_to: 4, loser_to: nil },
        { seats: [2,4], winner_to: 6, loser_to: nil }
      ]
      bracket = BracketTree::Bracket::Base.new matches: matches

      bracket.matches.should be_a Array
      bracket.matches.map(&:class).should == [BracketTree::Match, BracketTree::Match, BracketTree::Match]
    end
    
    it 'should create an empty if matches are not passed' do
      bracket.matches.should be_a Array
      bracket.matches.should == []
    end

    it 'should assign the seed order if seed_order is passed' do
      expected = [1,3,5,7]
      bracket = BracketTree::Bracket::Base.new seed_order: expected
      bracket.seed_order.should == expected
    end
  end

  describe '#add' do
    let(:root_payload) { { bar: 'bar' } }
    let(:payload) { { foo: 'foo' } }

    context 'no nodes present' do
      before do
        bracket.root.should be_nil
        bracket.add 4, root_payload
      end

      it 'should create a new Node at root' do
        bracket.root.should be_a_kind_of BracketTree::Node
      end

      it 'should set the payload of the new node to the passed object' do
        bracket.root.payload.should == root_payload
      end

      it 'should set the position of the root node to the passed position' do
        bracket.root.position.should == 4
      end
    end

    context 'root node present' do
      before do
        bracket.add 4, root_payload
        bracket.add 2, payload
      end

      it 'should add a node to the left position of root' do
        bracket.root.left.should be_a_kind_of BracketTree::Node
      end

      it 'should have the payload of the new node' do
        bracket.root.left.payload.should == payload
      end

      it 'should have the position of the new node' do
        bracket.root.left.position.should == 2
      end
    end

    context 'two nodes present' do
      let(:new_payload) { { baz: 'baz' } }
      before do
        bracket.add 4, root_payload
        bracket.add 2, payload

        bracket.root.left.right.should be_nil
        bracket.add 3, new_payload
      end

      it 'should add the new node to the left node right' do
        bracket.root.left.right.should be_a_kind_of BracketTree::Node
      end

      it 'should add the payload of the new node' do
        bracket.root.left.right.payload.should == new_payload
      end

      it 'should add the position of the new node' do
        bracket.root.left.right.position.should == 3
      end
    end
  end

  describe '#seats' do
    let(:bracket) { BracketTree::Bracket::SingleElimination.by_size 4 }

    it 'should return 7 seats' do
      bracket.seats.should have(7).seats
    end

    it 'should return them in insertion order' do
      bracket.seats.map { |n| n.position }.should == bracket.insertion_order
    end
  end

  describe '#replace' do
    before do
      bracket.add 3, { foo: 'foo' }
      bracket.add 2, { bar: 'bar' }
      bracket.add 4, { baz: 'baz' }
    end

    it 'replaces the payload at a given position with new payload' do
      bracket.replace 3, { winner: 'me' }

      bracket.root.payload.should == { winner: 'me' }
      bracket.root.left.payload.should == { bar: 'bar' }
      bracket.root.right.payload.should == { baz: 'baz' }
    end
  end

  describe "#size" do
    it "should return the number of nodes in the bracket" do
      bracket.add 3, { foo: 'foo' }
      bracket.add 2, { bar: 'bar' }
      bracket.add 4, { baz: 'baz' }
      bracket.size.should == 3
    end
  end

  describe "#at" do
    before do
      bracket.add 3, { foo: 'foo' }
      bracket.add 2, { bar: 'bar' }
      bracket.add 1, { baz: 'baz' }
    end
    it "should return the node at the given position in the bracket" do
      bracket.at(1).payload.should == { baz: 'baz'}
      bracket.at(2).payload.should == { bar: 'bar'}
      bracket.at(3).payload.should == { foo: 'foo'}
    end
  end

  describe '#seed' do
    let(:bracket) { BracketTree::Bracket::SingleElimination.by_size 4 }
    let(:players) do
      [
        { name: 'player4' },
        { name: 'player1' },
        { name: 'player3' },
        { name: 'player2' }
      ]
    end

    it 'should place the players in the bracket by seed order' do
      bracket.seed players

      bracket.at(1).payload.should == { name: 'player4' }
      bracket.at(3).payload.should == { name: 'player1' }
      bracket.at(5).payload.should == { name: 'player3' }
      bracket.at(7).payload.should == { name: 'player2' }
    end

    it 'should raise a NoSeedOrderError if seed order is not present in bracket' do
      bracket.seed_order = nil

      expect { bracket.seed players }.to raise_error(BracketTree::Bracket::NoSeedOrderError)
    end

    it 'should raise a SeedLimitExceededError if player count exceeds seed count' do
      players << { name: 'player5' }
      expect { bracket.seed players }.to raise_error(BracketTree::Bracket::SeedLimitExceededError)
    end
  end

  describe '#match_winner' do
    let(:bracket) { BracketTree::Bracket::DoubleElimination.by_size 4 }

    it 'copies the seat data to the seat specified in the match winner_to' do
      bracket.at(1).payload[:seed_value] = 1

      bracket.match_winner 1
      bracket.at(2).payload.should == bracket.at(1).payload
    end
  end

  describe 'positional relation hooks' do
    let(:bracket) { BracketTree::Bracket::DoubleElimination.by_size 4 }

    it 'delegates the query methods to a relation' do
      relation = bracket.winners
      relation.should be_a BracketTree::PositionalRelation
    end

    it 'delegates the accessor methods to a relation' do
      nodes = bracket.winners.round(1).all
      nodes.should have(4).nodes
    end
  end
end
