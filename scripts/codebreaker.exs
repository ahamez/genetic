defmodule Codebreaker do
  @behaviour Genetic.Problem

  use Bitwise

  alias Genetic.Types.Chromosome

  @impl true
  def genotype() do
    genes = random_genes()
    %Chromosome{genes: genes, size: length(genes)}
  end

  @impl true
  def fitness(%Chromosome{genes: genes}) do
    target = 'ILoveGeneticAlgorithms'
    encrypted = 'LIjs`B`k`qlfDibjwlqmhv'
    cipher = fn word, key -> Enum.map(word, &rem(&1 ^^^ key, 32768)) end

    key =
      genes
      |> Enum.map(&Integer.to_string/1)
      |> Enum.join("")
      |> String.to_integer(2)

    guess = List.to_string(cipher.(encrypted, key))
    String.jaro_distance(List.to_string(target), guess)
  end

  @impl true
  def terminate?(population, _generation, _temperature) do
    Enum.max_by(population, fn chromosome -> chromosome.fitness end).fitness == 1
  end

  defp random_genes() do
    for _ <- 1..64, do: Enum.random(0..1)
  end
end

soln =
  Genetic.run(Codebreaker,
    crossover_type: Genetic.Crossover.SinglePoint,
    mutation_type: Genetic.Mutation.Flip
  )

# soln = Genetic.run(Codebreaker)

{key, ""} =
  soln.genes
  |> Enum.map(&Integer.to_string/1)
  |> Enum.join("")
  |> Integer.parse(2)

IO.write("\nKey: #{key}\n")
