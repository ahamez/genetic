defmodule Speller do
  @behaviour Genetic.Problem

  # @target "anticonstitutionnellement"
  @target "abcabcabcabcabcabcabcabcabcabcabcabcabcabcabc"
  # @target "abcdefghijklmn"
  # @target "aaaaaaaaaaaaaa"

  alias Genetic.Types.Chromosome

  @impl true
  def genotype() do
    genes = random_genes()
    %Chromosome{genes: genes, size: length(genes)}
  end

  @impl true
  def fitness(%Chromosome{genes: genes}) do
    String.jaro_distance(@target, to_string(genes))
  end

  @impl true
  def terminate?(population, _generation, _temperature) do
    best_chromosome = hd(population)
    best_chromosome.fitness == 1
  end

  defp random_genes() do
    for _ <- 1..String.length(@target), do: Enum.random(?a..?z)
  end
end

solution =
  Genetic.run(Speller, population_size: 1000, crossover_type: Genetic.Crossover.SinglePoint)

IO.write("\n")
IO.inspect(solution)
