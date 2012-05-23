require 'spec_helper'

class TestTemplate < BracketTree::Template::Base
  def self.location
    File.join File.dirname(__FILE__), '../', 'lib/bracket_tree/templates/single_elimination'
  end
end

describe BracketTree::Template::Base do
  def template_json
    {
      'startingSeats' => [1,3,5,7],
      'seats' => [
        { 'position' => 4 },
        { 'position' => 2 },
        { 'position' => 6 },
        { 'position' => 1 },
        { 'position' => 3 },
        { 'position' => 5 },
        { 'position' => 7 }
      ],
      'nodes' => []
    }
  end

  describe '#by_size' do
    it 'should return the Template based on the player size passed' do
      template = TestTemplate.by_size 4

      template.should be_a TestTemplate
      template.seats.should have(7).seats
      template.nodes.should have(3).nodes
    end

    it 'should return nil if template JSON does not exist' do
      template = TestTemplate.by_size 5

      template.should be_nil
    end
  end

  describe '#from_json' do
    it 'should generate the Template from the JSON template' do
      template = TestTemplate.from_json template_json

      template.should be_a TestTemplate
      template.seats.should have(7).seats
      template.starting_seats.should == [1,3,5,7]
    end
  end

  describe '#to_h' do
    it' should return a hash containing the bracket template' do
      template = TestTemplate.from_json template_json
      template.to_h.should == template_json
    end
  end

  describe '#generate_blank_bracket' do
    it 'should return a Bracket object with empty hashes in the seats' do
      template = TestTemplate.by_size 4
      bracket = template.generate_blank_bracket

      bracket.should be_a BracketTree::Bracket
      bracket.size.should == 7
      bracket.to_a.map { |n| n.payload }.should == [{}, {}, {}, {}, {}, {}, {}]
    end
  end
end
