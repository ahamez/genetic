defmodule NQueens do
  @behaviour Genetic.Problem

  alias Genetic.Types.Chromosome

  @impl true
  def genotype() do
    genes = random_genes()
    %Chromosome{genes: genes, size: length(genes)}
  end

  @impl true
  def fitness(%Chromosome{genes: genes}) do
    # My custom fitness function
    # {_, fitness} = Enum.reduce(genes, {1, 0}, fn row, {i, fitness} ->
    #   {_, board_on_right} = Enum.split(genes, i)

    #   {_, fitness} = Enum.reduce(board_on_right, {1, fitness}, fn row2, {j, acc} ->
    #     if row == row2 or row == (row2 + j) or row == (row2 - j)  do
    #       # IO.write("conflict for #{row} and #{row2}\n")
    #       {j + 1, acc + 0}
    #     else
    #       {j + 1, acc + 1}
    #     end
    #   end)

    #   {i + 1, fitness}
    # end)

    # fitness

    # Book fitness function
    diag_clashes =
      for i <- 0..7, j <- 0..7 do
        if i != j do
          dx = abs(i - j)
          dy = abs(genes |> Enum.at(i) |> Kernel.-(Enum.at(genes, j)))

          if dx == dy do
            1
          else
            0
          end
        else
          0
        end
      end

    length(Enum.uniq(genes)) - Enum.sum(diag_clashes)
  end

  @impl true
  def terminate?(population, _generation, _temperature) do
    # Enum.max_by(population, fn chromosome -> chromosome.fitness end).fitness == 28
    Enum.max_by(population, fn chromosome -> chromosome.fitness end).fitness == 8
  end

  defp random_genes() do
    Enum.shuffle(0..7)
  end
end

# Some conflicts
# c = %Genetic.Types.Chromosome{age: 0, fitness: 0, genes: [0, 2, 1, 3, 6, 4, 7, 5]}

# No conflict
# c = %Genetic.Types.Chromosome{age: 0, fitness: 0, genes: [3, 1, 6, 2, 5, 7, 4, 0], size: 8}

# All rows conflict
# c = %Genetic.Types.Chromosome{age: 0, fitness: 0, genes: [0, 0, 0, 0, 0, 0, 0, 0]}
# IO.inspect(c)

# fitness = NQueens.fitness(c)
# IO.inspect(fitness)

# solution = Genetic.run(NQueens, crossover_type:Genetic.Crossover.SinglePoint, population_size: 10)
solution = Genetic.run(NQueens, crossover_type: Genetic.Crossover.Uniform)
# solution = Genetic.run(NQueens)
IO.write("\n")
IO.inspect(solution)
