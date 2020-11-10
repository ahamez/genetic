defmodule Genetic.Crossover.Uniform do
  @behaviour Genetic.Crossover

  alias Genetic.Types.Chromosome

  @impl true
  def crossover(parent1, parent2, opts) do
    rate = Keyword.fetch!(opts, :uniform_rate)
    {child1, child2} = uniform([], [], parent1.genes, parent2.genes, rate)

    {
      %Chromosome{genes: child1, size: parent1.size},
      %Chromosome{genes: child2, size: parent1.size}
    }
  end

  defp uniform(child1, child2, [], [], _rate) do
    {Enum.reverse(child1), Enum.reverse(child2)}
  end

  defp uniform(child1, child2, [p1 | parent1], [p2 | parent2], rate) do
    if :rand.uniform() < rate do
      uniform([p2 | child1], [p1 | child2], parent1, parent2, rate)
    else
      uniform([p1 | child1], [p2 | child2], parent1, parent2, rate)
    end
  end
end
