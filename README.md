# BracketTree

BracketTree is a bracketing system built around the BracketTree Data Specification,
which uses a three-section data structure built on top of JSON to convey the visual
representation, progression logic, and seed mapping in a serializable format.  For
more information on the data specification, please read the 
[BracketTree Data Specification](https://github.com/agoragames/bracket_tree/wiki/BracketTree-Data-Specification).

BracketTree builds upon the specification by providing Ruby classes for programmatically
generating templates for brackets and generating brackets from those templates. It
also contains a number of common bracket template types like Single Elimination and
Double Elimination, with the ability to put your own extensions on their logic and
representation.

BracketTree is broken into two fundamental components: Templates and Brackets.

## BracketTree Templates

Templates in BracketTree are the instructions on how a Bracket is to be constructed,
containing the three components of a BracketTree specification:

- `starting_seats`
- `seats`
- `nodes`

BracketTree comes with a number of default templates included. To access one, call
the `by_size` method on the template class.  For example, to generate an eight-player,
double-elimination bracket template:

```
template = BracketTree::Template::DoubleElimination.by_size(8)
```

The resulting BracketTree::Template::DoubleElimination object contains the necessary
details to create a bracket using its information.

If you need to make customizations, you can manipulate the template per object, like
in this example where we reverse the seed order of the template:

```
template = BracketTree::Template::DoubleElimination.by_size(8)
template.starting_seats # => [1,3,5,7,9,11,13,15]
template.starting_seats = [15,13,11,9,7,5,3,1]
```

However, you may wish to generate your own Template class. To do so, subclass the 
`BracketTree::Template::Base` class and define `location` to be the location of the
JSON files that conform to the [BracketTree Data Specification](https://github.com/agoragames/bracket_tree/wiki/BracketTree-Data-Specification).
In this example, we create a class for the MLG Double Elimination format, where the 
templates are located in the `mlg_double` directory:

```
class BracketTree::Template::MLGDouble < BracketTree::Template::Base
  def location ; File.join File.dirname(__FILE__), 'mlg_double' ; end
end
```

If you happen to have the JSON already stored as a hash and want to create a Template
from that, you can use the `from_json` method to generate a new template:

```
hash = {
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

template = BracketTree::Template::Base.from_json hash
```

Once have a template instantiated, we can generate a blank Bracket from the template.

```
template = BracketTree::Template::DoubleElimination.by_size(8)
bracket  = template.generate_blank_bracket
```

## BracketTree Brackets

Once we've generated a bracket from a template, we're able to start populating and
controlling the bracket information.  `BracketTree::Bracket` objects, when not created
from a Template, are blank binary trees.  If you happen to know the math involved in
hand-crafting a binary tree reflective of your particular tournament type, then you
could use `add` to start adding nodes in the bracket:

```
bracket = BracketTree::Bracket.new
bracket.add 2, { player: 'player1' }
bracket.add 1, { player: 'player1' }
bracket.add 3, { player: 'player2' }
```

While this is not the most difficult thing to do on a small scale, doing this for
larger tournaments is extremely cumbersome, so we generate Brackets from Templates
instead.  Please review 'BracketTree Templates' for more information on this.

When you generate a blank bracket from a template, it adds empty hashes as 
placeholders for all of the seats in the Bracket.  To replace these placeholders, use
the `replace` method with the seat position and the object you would like to replace
it with.

In this example, we handle seeding a two-player, single elimination bracket:

```
bracket = BracketTree::Template::SingleElimination.by_size(2).generate_blank_bracket
bracket.replace 1, { player: 'player1' }
bracket.replace 3, { player: 'player3' }
```

Again, this is not the most difficult thing to do, but seeding is a pretty common
thing.  For actions like this, use the `seed` method.

Under the hood, each seat position in the Bracket is held as the payload of a `Node`
object.  This contains the binary tree traversal controls, as well as a `payload`
property that contains the object being stored at the node.  When using any iterator
methods from `Enumerable` on a bracket, know that they are in the context of a `Node`
 rather than whatever you have chosen to store inside the `Node`.  This allows the 
following:

```
bracket = BracketTree::Template::SingleElimination.by_size(2).generate_blank_bracket
bracket.replace 2, { player: 'player1 }

node = bracket.find { |n| n.position == 2 }
node.payload # => { player: 'player1' }
node.payload[:seed_value] = 3
```

## Example

Below is an example of creating a 32-player, double elimination tournament bracket
template, generating a blank bracket, seeding from an array of players, and filling
some results from round 1:

```
players = []
32.times do |n| 
  players << { login: "Player#{n}", seed_value: n }
end

bracket = BracketTree::Template::DoubleElimination.by_size(32).generate_blank_bracket
bracket.seed players

# Player1 wins Rd 1
bracket.find { |n| n.position == 1 }.payload[:winner] = true
bracket.replace 2, { login: "Player1", seed_value: 1 }

# Player3 wins Rd 1
bracket.find { |n| n.position == 5 }.payload[:winner] = true
bracket.replace 6, { login: "Player3", seed_value: 3 }
```
