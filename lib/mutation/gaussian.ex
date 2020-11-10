defmodule Genetic.Mutation.Gaussian do
  @behaviour Genetic.Mutation

  use Bitwise

  alias Genetic.Types.Chromosome

  @impl true
  def mutation(chromosome = %Chromosome{genes: genes, size: size}, _opts) do
    mu = Enum.sum(genes) / size
    sigma = Enum.reduce(genes, 0, fn g, acc -> (mu - g) * (mu - g) + acc end) / size
    genes = Enum.map(genes, fn _ -> :rand.normal(mu, sigma) end)

    %Chromosome{chromosome | genes: genes}
  end
end
