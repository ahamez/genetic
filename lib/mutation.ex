defmodule Genetic.Mutation do
  alias Genetic.Types.Chromosome

  @callback mutation(Chromosome.t(), Keyword.t()) :: Chromosome.t()
end
