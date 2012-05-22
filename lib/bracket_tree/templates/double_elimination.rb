module BracketTree
  module Template
    # Template for double-elimination-based tournament formats. Uses the 'right' half
    # of the binary tree for the loser's bracket and the 'left' half for the winner's
    class DoubleElimination < Base
      class << self
        def location
          File.join File.dirname(__FILE__), 'templates', 'double_elimination'
        end
      end
    end
  end
end
