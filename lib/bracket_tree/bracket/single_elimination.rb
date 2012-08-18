module BracketTree
  module Bracket
    class SingleElimination < Base
      template BracketTree::Template::SingleElimination
      include PositionalRelationDelegators
    end
  end
end
