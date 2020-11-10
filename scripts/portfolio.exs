defmodule Portfolio do
  @behaviour Genetic.Problem

  alias Genetic.Types.Chromosome

  @impl true
  def genotype() do
    genes = random_genes()
    %Chromosome{genes: genes, size: length(genes)}
  end

  @impl true
  def fitness(%Chromosome{genes: genes}) do
    Enum.reduce(genes, 0, fn {roi, risk}, acc -> acc + 2 * roi - risk end)
  end

  @impl true
  def terminate?(population, _generation, _temperature) do
    Enum.max_by(population, fn chromosome -> chromosome.fitness end) == 10
  end

  defp random_genes() do
    for _ <- 1..100, do: {:rand.uniform(10), :rand.uniform(10)}
  end
end

solution =
  Genetic.run(Portfolio, csv_file: "portfolio.csv", crossover_type: Genetic.Crossover.SinglePoint)

IO.write("\n")
IO.inspect(solution)
