defmodule OneMax do
  @behaviour Genetic.Problem

  alias Genetic.Types.Chromosome

  @impl true
  def genotype() do
    genes = random_genes()
    %Chromosome{genes: genes, size: length(genes)}
  end

  @impl true
  def fitness(%Chromosome{genes: genes}) do
    Enum.sum(genes)
  end

  @impl true
  def terminate?(population, _generation, _temperature) do
    # Population is sorted by fitness
    best_chromosome = hd(population)
    best_chromosome.fitness == 100
  end

  defp random_genes() do
    for _ <- 1..100, do: Enum.random(0..1)
  end
end

solution =
  Genetic.run(OneMax,
    crossover_type: Genetic.Crossover.Uniform,
    selection_type: Genetic.Selection.Random,
    population_size: 1000
  )

IO.write("\n")
IO.inspect(solution)
