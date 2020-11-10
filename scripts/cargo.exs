defmodule Load do
  @enforce_keys [:profit, :weight]
  defstruct [:profit, :weight]
end

defmodule Cargo do
  @behaviour Genetic.Problem

  @weight_limit 40
  @loads [
    %Load{weight: 10, profit: 6},
    %Load{weight: 6, profit: 5},
    %Load{weight: 8, profit: 8},
    %Load{weight: 7, profit: 9},
    %Load{weight: 10, profit: 6},
    %Load{weight: 9, profit: 7},
    %Load{weight: 7, profit: 3},
    %Load{weight: 11, profit: 1},
    %Load{weight: 6, profit: 2},
    %Load{weight: 8, profit: 6}
  ]

  alias Genetic.Types.Chromosome

  @impl true
  def genotype() do
    genes = random_genes()
    %Chromosome{genes: genes, size: length(genes)}
  end

  @impl true
  def fitness(chromosome) do
    {weight, profit} = compute_cargo_profit_weight(chromosome)

    if weight > @weight_limit do
      0
    else
      profit
    end
  end

  @impl true
  def terminate?(_population, generation, _temperature) do
    generation >= 10_000
    # generation >= 1_000_000 and temperature < 0
  end

  defp random_genes() do
    for _ <- 1..10, do: Enum.random(0..1)
  end

  def compute_cargo_profit_weight(%Chromosome{genes: genes}) do
    genes
    |> Enum.zip(@loads)
    |> Enum.reduce({0, 0}, fn {c, load}, {weight, profit} ->
      {
        c * load.weight + weight,
        c * load.profit + profit
      }
    end)
  end
end

# solution = Genetic.run(Cargo, csv_file: "cargo.csv")
solution = Genetic.run(Cargo)
IO.write("\n")
IO.inspect(solution)
{weight, profit} = Cargo.compute_cargo_profit_weight(solution)
IO.write("Weight: #{weight} Profit: #{profit}")
