require 'spec_helper'

describe BracketTree::Bracket do
  describe '#add' do
    let(:root_payload) { { bar: 'bar' } }
    let(:payload) { { foo: 'foo' } }

    context 'no nodes present' do
      before do
        subject.root.should be_nil
        subject.add 4, root_payload
      end

      it 'should create a new Node at root' do
        subject.root.should be_a_kind_of BracketTree::Node
      end

      it 'should set the payload of the new node to the passed object' do
        subject.root.payload.should == root_payload
      end

      it 'should set the position of the root node to the passed position' do
        subject.root.position.should == 4
      end
    end

    context 'root node present' do
      before do
        subject.add 4, root_payload
        subject.add 2, payload
      end

      it 'should add a node to the left position of root' do
        subject.root.left.should be_a_kind_of BracketTree::Node
      end

      it 'should have the payload of the new node' do
        subject.root.left.payload.should == payload
      end

      it 'should have the position of the new node' do
        subject.root.left.position.should == 2
      end
    end

    context 'two nodes present' do
      let(:new_payload) { { baz: 'baz' } }
      before do
        subject.add 4, root_payload
        subject.add 2, payload

        subject.root.left.right.should be_nil
        subject.add 3, new_payload
      end

      it 'should add the new node to the left node right' do
        subject.root.left.right.should be_a_kind_of BracketTree::Node
      end

      it 'should add the payload of the new node' do
        subject.root.left.right.payload.should == new_payload
      end

      it 'should add the position of the new node' do
        subject.root.left.right.position.should == 3
      end
    end
  end

  describe '#nodes' do
    let(:payload1) { { foo: 'foo' } }
    let(:payload2) { { bar: 'bar' } }
    let(:payload3) { { baz: 'baz' } }

    before do
      subject.add 4, payload1
      subject.add 2, payload2
      subject.add 3, payload3
    end

    it 'should return 3 node objects' do
      subject.nodes.should have(3).nodes
    end

    it 'should return them in insertion order' do
      subject.nodes.map { |n| n.position }.should == [4,2,3]
    end
  end
end
