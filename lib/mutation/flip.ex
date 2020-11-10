defmodule Genetic.Mutation.Flip do
  @behaviour Genetic.Mutation

  use Bitwise

  alias Genetic.Types.Chromosome

  @impl true
  def mutation(chromosome, opts) do
    flip_rate = Keyword.fetch!(opts, :flip_rate)

    genes =
      Enum.map(chromosome.genes, fn g ->
        if :rand.uniform() < flip_rate do
          g ^^^ 1
        else
          g
        end
      end)

    %Chromosome{chromosome | genes: genes}
  end
end
