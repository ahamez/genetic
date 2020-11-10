defmodule Genetic.Crossover do
  alias Genetic.Types.Chromosome

  @callback crossover(Chromosome.t(), Chromosome.t(), Keyword.t()) ::
              {Chromosome.t(), Chromosome.t()}
end
