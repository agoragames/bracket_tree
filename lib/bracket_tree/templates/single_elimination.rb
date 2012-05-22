module BracketTree
  module Template
    class SingleElimination < Base
      class << self
        def location
          File.join File.dirname(__FILE__), 'single_elimination'
        end
      end
    end
  end
end
