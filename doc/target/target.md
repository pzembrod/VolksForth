# The target compiler

## Ghosts

Ghosts are created as placeholder words in case an undefined word is used
during a target compile run. This enables forward refernces, i.e. using words
before they are defined.

A ghost is placed on the heap and has the following format:
```
╔════════════════════════════════════════════════════╗
║lfa║name + " "║cfa.Ghost║cfa.Target║Ptr to Does>.cfa║
╚════════════════════════════════════════════════════╝
```

