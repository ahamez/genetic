defmodule Genetic.Mutation.Scramble do
  @behaviour Genetic.Mutation

  alias Genetic.Types.Chromosome

  @impl true
  def mutation(chromosome, _opts) do
    %Chromosome{chromosome | genes: Enum.shuffle(chromosome.genes)}
  end
end
