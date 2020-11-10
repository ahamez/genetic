defmodule Genetic.Problem do
  alias Genetic.Types.Chromosome

  @callback genotype :: Chromosome.t()
  @callback fitness(Chromosome.t()) :: integer()
  @callback terminate?(Enum.t(), integer(), integer()) :: boolean()
end
