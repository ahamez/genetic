defmodule Genetic.Conf do
  defstruct cooling_rate: 0.2,
            population_size: 100,
            csv_file: nil,
            selection_type: Genetic.Selection.Natural,
            selection_rate: 0.9,
            crossover_type: Genetic.Crossover.OrderOne,
            crossover_opts: [uniform_rate: 0.5],
            mutation_type: Genetic.Mutation.Scramble,
            mutation_rate: 0.05,
            mutation_opts: [flip_rate: 0.4]

  def new(opts) do
    default = %__MODULE__{}

    %__MODULE__{
      cooling_rate: Keyword.get(opts, :cooling_rate, default.cooling_rate),
      population_size: Keyword.get(opts, :population_size, default.population_size),
      csv_file:
        case Keyword.get(opts, :csv_file) do
          nil ->
            nil

          path ->
            {:ok, file} = File.open(path, [:write])
            file
        end,
      selection_type: Keyword.get(opts, :selection_type, default.selection_type),
      selection_rate: Keyword.get(opts, :selection_rate, default.selection_rate),
      crossover_type: Keyword.get(opts, :crossover_type, default.crossover_type),
      crossover_opts: Keyword.get(opts, :crossover_opts, default.crossover_opts),
      mutation_type: Keyword.get(opts, :mutation_type, default.mutation_type),
      mutation_rate: Keyword.get(opts, :mutation_rate, default.mutation_rate),
      mutation_opts: Keyword.get(opts, :mutation_opts, default.mutation_opts)
    }
  end
end
