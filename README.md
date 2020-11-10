# Genetic

A take on the book ["Genetic Algorithms in Elixir"](https://pragprog.com/titles/smgaelixir/genetic-algorithms-in-elixir/).

## Main differences
- All modules are prefixed with `Genetic`
- Use behaviours rather than functions called with `apply()` to model crossover, mutation, etc.
- Add a `Genetic.Conf` module to centralize configuration
