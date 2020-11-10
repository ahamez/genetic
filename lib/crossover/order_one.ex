defmodule Genetic.Crossover.OrderOne do
  @behaviour Genetic.Crossover

  alias Genetic.Types.Chromosome

  @impl true
  def crossover(parent1, parent2, _opts) do
    {i1, i2} = random_range(parent1.size - 1)

    # parent2 contribution
    slice1 = Enum.slice(parent1.genes, i1..i2)
    slice1_set = MapSet.new(slice1)
    parent2_contrib = Enum.reject(parent2.genes, &MapSet.member?(slice1_set, &1))
    {head1, tail1} = Enum.split(parent2_contrib, i1)

    # parent1 contribution
    slice2 = Enum.slice(parent2.genes, i1..i2)
    slice2_set = MapSet.new(slice2)

    parent1_contrib = Enum.reject(parent1.genes, &MapSet.member?(slice2_set, &1))
    {head2, tail2} = Enum.split(parent1_contrib, i1)

    {
      %Chromosome{
        genes: head1 ++ slice1 ++ tail1,
        size: parent1.size
      },
      %Chromosome{
        genes: head2 ++ slice2 ++ tail2,
        size: parent1.size
      }
    }
  end

  defp random_range(size) do
    i1 = :rand.uniform(size)
    i2 = :rand.uniform(size)

    if i1 < i2 do
      {i1, i2}
    else
      {i2, i1}
    end
  end
end
