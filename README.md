# BracketTree

BracketTree::Bracket is a binary tree-based bracket system.

## Usage


*add* (position, data)

This adds a Node to the bracket containing `data`.

*nodes*

Returns an Array of Nodes sorted by insertion order, preserving the binary tree.

*to_h*

Returns a Hash representing the binary tree of the bracket.

## Example

```
seats = [4,2,6,1,3,5,7]
bracket = BracketTree::Bracket

seats.each do |position|
  bracket.add position, { login: "TestPlayer#{position}" }
end

bracket.to_h

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
