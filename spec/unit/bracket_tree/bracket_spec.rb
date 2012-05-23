require 'spec_helper'

describe BracketTree::Bracket do
  let(:bracket) { BracketTree::Bracket.new }

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

  describe '#nodes' do
    let(:payload1) { { foo: 'foo' } }
    let(:payload2) { { bar: 'bar' } }
    let(:payload3) { { baz: 'baz' } }

    before do
      bracket.add 4, payload1
      bracket.add 2, payload2
      bracket.add 3, payload3
    end

    it 'should return 3 node objects' do
      bracket.nodes.should have(3).nodes
    end

    it 'should return them in insertion order' do
      bracket.nodes.map { |n| n.position }.should == [4,2,3]
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

  describe "#add_winner" do
    it "should destructure the incoming data as the root's payload" do
      bracket.add 1, { name: 'well, it was me' }
      bracket.add_winner( { name: 'but now it is me', awyeah: true } )
      bracket.winner.should == { name: 'but now it is me', awyeah: true }
    end
    it "should create the root node if it needs to" do
      bracket.size.should == 0
      bracket.add_winner( { name: 'but now it is me', awyeah: true } )
      bracket.winner.should == { name: 'but now it is me', awyeah: true }
    end
  end

  describe '#seed' do
    let(:bracket) { BracketTree::Template::SingleElimination.by_size(4).generate_blank_bracket }
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

      bracket.find { |n| n.position == 1 }.payload.should == { name: 'player4' }
      bracket.find { |n| n.position == 3 }.payload.should == { name: 'player1' }
      bracket.find { |n| n.position == 5 }.payload.should == { name: 'player3' }
      bracket.find { |n| n.position == 7 }.payload.should == { name: 'player2' }
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
end
