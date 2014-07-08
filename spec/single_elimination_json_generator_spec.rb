require 'pry'
require 'spec_helper'

module BracketTree
  module Template
    describe SingleEliminationGenerator do
      def hash_from_single_elimination_json(n)
        filename = "../../lib/bracket_tree/templates/single_elimination/#{n}.json"
        JSON.parse File.read(File.expand_path filename, __FILE__), :symbolize_names => true

      end

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
          subject { SingleEliminationGenerator.new(16) }

          it 'builds seats as expected' do
            subject.populate_matches
            subject.populate_seats
            subject.seats[1].should == {:position => 8}
          end
        end

        describe '#to_hash' do
          context 'when building a 8 seats tree' do
            subject { SingleEliminationGenerator.new(8) }
            let(:expected) { hash_from_single_elimination_json 8 }

            it 'builds expected json 8' do
              subject.build
              subject.to_hash.should == expected.symbolize_keys
            end
          end

          context 'when building a 16 seats tree' do
            subject { SingleEliminationGenerator.new 16 }
            let(:expected) { hash_from_single_elimination_json 16 }

            it 'builds expected json 16' do
              subject.build
              subject.to_hash.should == expected.symbolize_keys
            end
          end

          context 'when building a 32 seats tree' do
            subject { SingleEliminationGenerator.new 32 }
            let(:expected) { hash_from_single_elimination_json 32 }

            it 'builds expected json 32' do
              subject.build
              subject.to_hash.should == expected.symbolize_keys
            end
          end

          context 'when building a 64 seats tree' do
            subject { SingleEliminationGenerator.new 64 }
            let(:expected) { hash_from_single_elimination_json 64 }

            it 'builds expected json 64' do
              subject.build
              subject.to_hash.should == expected.symbolize_keys
            end
          end

          context 'when building a 128 seats tree' do
            subject { SingleEliminationGenerator.new 128 }
            let(:expected) { hash_from_single_elimination_json 128 }

            it 'builds expected json 128' do
              subject.build
              result = subject.to_hash
              result[:matches].should        == expected[:matches]
              result[:starting_seats].should == expected[:starting_seats]
            end

            it 'has problems with seats' do
              subject.build
              subject.to_hash[:seats].should == expected[:seats]
            end
          end

          context 'when building a 256 seats tree' do
            subject { SingleEliminationGenerator.new 256 }

            it 'builds the json' do
              subject.build
              subject.to_json.should_not raise_error
            end
          end

          context 'when building a 512 seats tree' do
            subject { SingleEliminationGenerator.new 512 }

            it 'builds the json' do
              subject.build
              subject.to_json.should_not raise_error
            end
          end

          context 'when building a 1024 seats tree' do
            subject { SingleEliminationGenerator.new 1024 }

            it 'builds the json' do
              subject.build
              subject.to_json.should_not raise_error
            end
          end
        end
      end
    end
  end
end