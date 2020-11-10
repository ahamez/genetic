defmodule Schedule do
  @behaviour Genetic.Problem

  alias Genetic.Types.Chromosome

  @credit_hours [3.0, 3.0, 3.0, 4.5, 3.0, 3.0, 3.0, 3.0, 4.5, 1.5]
  @difficulties [8.0, 9.0, 4.0, 3.0, 5.0, 2.0, 4.0, 2.0, 6.0, 1.0]
  @usfulness [8.0, 9.0, 6.0, 2.0, 8.0, 9.0, 1.0, 2.0, 5.0, 1.0]
  @interest [8.0, 9.0, 5.0, 9.0, 7.0, 2.0, 8.0, 2.0, 7.0, 10.0]

  @weights Enum.zip([@difficulties, @usfulness, @interest])

  @max_credits 18.0

  @impl true
  def genotype() do
    genes = random_genes()
    %Chromosome{genes: genes, size: length(genes)}
  end

  @impl true
  def fitness(%Chromosome{genes: schedule}) do
    credits = credits(schedule)

    if credits > @max_credits do
      -999_999_999
    else
      schedule
      |> Enum.zip(@weights)
      |> Enum.reduce(0, fn {class, {difficulty, usfulness, interest}}, acc ->
        acc + class * (0.3 * difficulty + 0.3 * usfulness + 0.3 * interest)
      end)
    end
  end

  @impl true
  def terminate?(population, generation, _temperature) do
    generation > 1000 and credits(hd(population).genes) == 18.0
  end

  defp random_genes() do
    for _ <- 1..10, do: Enum.random(0..1)
  end

  def credits(schedule) do
    schedule
    |> Enum.zip(@credit_hours())
    |> Enum.reduce(0, fn {class, credits}, acc -> acc + class * credits end)
  end
end

# solution = Genetic.run(Schedule, crossover_type: Genetic.Crossover.SinglePoint, mutation_type: Genetic.Mutation.Flip)
solution =
  Genetic.run(Schedule,
    crossover_type: Genetic.Crossover.OrderOne,
    mutation_type: Genetic.Mutation.Flip
  )

# solution = Genetic.run(Schedule)

IO.write("\n")
IO.inspect(solution, label: "➡️")
IO.write("Credits: #{Schedule.credits(solution.genes)}")
