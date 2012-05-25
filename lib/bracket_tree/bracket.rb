require 'bracket_tree/node'
require 'bracket_tree/bracket/base'
module BracketTree
  module Bracket
    class NoSeedOrderError < Exception ; end
    class SeedLimitExceededError < Exception ; end

    autoload :Base,               'bracket_tree/bracket/base'
    autoload :SingleElimination,  'bracket_tree/bracket/single_elimination'
    autoload :DoubleElimination,  'bracket_tree/bracket/double_elimination'
  end
end
