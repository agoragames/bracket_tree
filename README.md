# BracketTree

BracketTree::Bracket

```
seats = [4,2,6,1,3,5,7]
bracket = BracketTree::Bracket

seats.each do |position|
  bracket.add position, { login: "TestPlayer#{position}" }
end

bracket.to_h.inspect

{
  :payload => {
    :login => "TestPlayer4"
  }, 
  :left => {
    :payload => {
      :login => "TestPlayer2"
    }, 
    :left => {
      :payload => {
        :login => "TestPlayer1"
      }, 
      :left => nil, 
      :right => nil
    }, 
    :right => {
      :payload => {
        :login => "TestPlayer3"
      }, 
      :left=>nil, 
      :right=>nil
    }
  }, 
  :right => {
    :payload => { 
      :login => "TestPlayer6"
    }, 
    :left => {
      :payload => {
        :login => "TestPlayer5"
      }, 
      :left => nil, 
      :right => nil
    }, 
    :right => {
      :payload => {
        :login => "TestPlayer7"
      }, 
      :left => nil, 
      :right => nil
    }
  }
}
```
