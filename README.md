BracketTree.new(@bracket)

```
bracket = BracketTree::Bracket.generate(size: 16, type: 'single-elim')
```

Advanced
```
template = BracketTree::Templates::DoubleElimination.new(16)
players = []
16.times { |n| players << {player: "RandomPlayer#{n}" } }
bracket = BracketTree::Bracket.generate(template: template, players: players)
```

Already have your seats mapped? Great!

```
array_of_seats = [
  { position: 1, player: 'RandomPlayer1' },
  { position: 3, player: 'RandomPlayer2' },
  { position: 2, player: 'RandomPlayer1' }
]

bracket = BracketTree::Bracket.generate(size: 2, type: 'single-elim', seats: array_of_seats)
```


Crazy experimental shit, takes games and maps them to seats in a bracket template.
By default, it fills in the order of seats, which means the top half will fill entirely
before the bottom half, but you can optionally pass the `half` key to tell it to fill
from the bottom half.


```
games = [
  {
    top_seed: {
      player: 'Player 1',
      seed_value: 1
    },
    bottom_seed: {
      player: 'Player 4',
      seed_value: 4
    },
    winner: 1
  },
  {
    top_seed: {
      player: 'Player 3',
      seed_value: 3
    },
    bottom_seed: {
      player: 'Player 2',
      seed_value: 2
    },
    winner: 2
  },
  {
    top_seed: {
      player: 'Player 1',
      seed_value: 1
    },
    bottom_seed: {
      player: 'Player 2',
      seed_value: 2
    },
    winner: 1
  }
]
bracket = BracketTree::Bracket.generate_blank(size: 16, type: 'single-elim')
bracket.add_game(games[0])
bracket.add_game(games[1], half: :bottom)
bracket.add_game(games[2])
```
