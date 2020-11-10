defmodule Genetic.Types.Chromosome do
  @type t :: %__MODULE__{
          genes: Enum.t(),
          fitness: number(),
          age: integer(),
          size: integer()
        }

  @enforce_keys [:genes, :size]
  defstruct [:genes, :size, fitness: 0, age: 0]
end
