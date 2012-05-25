module BracketTree
  module Template
    class DoubleElimination < Base
      class << self
        def location
          File.join File.dirname(__FILE__), 'double_elimination'
        end
      end
    end
  end
end
