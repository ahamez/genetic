defmodule Genetic.Crossover.SinglePoint do
  @behaviour Genetic.Crossover

  alias Genetic.Types.Chromosome

  @impl true
  def crossover(parent1, parent2, _opts) do
    crossover_point = :rand.uniform(parent1.size)

    {parent1_head, parent1_tail} = Enum.split(parent1.genes, crossover_point)
    {parent2_head, parent2_tail} = Enum.split(parent2.genes, crossover_point)

    {
      %Chromosome{genes: parent1_head ++ parent2_tail, size: parent1.size},
      %Chromosome{genes: parent2_head ++ parent1_tail, size: parent1.size}
    }
  end
end
