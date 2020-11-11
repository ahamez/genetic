defmodule Genetic do
  alias Genetic.Types.Chromosome
  alias NimbleCSV.RFC4180, as: CSV

  @compile {:inline, temperature: 3}

  defmodule Context do
    defstruct generation: 0,
              last_max_fitness: 0,
              temperature: 0
  end

  def run(problem, opts \\ []) do
    conf = Genetic.Conf.new(opts)
    IO.inspect(conf)
    population = initialize(problem, conf)
    evolve(population, problem, %Context{}, conf)
  end

  defp evolve(population, problem, ctx, conf) do
    population =
      population
      |> evaluate(problem)
      |> sort_population_by_fitness()

    best_chromosome = hd(population)
    best_fitness = best_chromosome.fitness
    temperature = temperature(best_fitness, ctx, conf)

    ctx = %Context{
      ctx
      | generation: ctx.generation + 1,
        last_max_fitness: best_fitness,
        temperature: temperature
    }

    IO.write("\rCurrent best chromosome fitness: #{inspect(best_chromosome.fitness)}")
    write_stats(conf.csv_file, ctx)

    if problem.terminate?(population, ctx.generation, ctx.temperature) do
      best_chromosome
    else
      {parents, leftovers} = select(population, conf)

      children = crossover(parents, conf)

      (children ++ leftovers)
      |> mutation(conf)
      |> evolve(problem, ctx, conf)
    end
  end

  defp write_stats(nil, _ctx), do: :ok

  defp write_stats(file, ctx) do
    iodata = CSV.dump_to_iodata([[ctx.generation, ctx.last_max_fitness, ctx.temperature]])
    IO.write(file, iodata)
  end

  defp temperature(best_fitness, ctx, conf) do
    (1 - conf.cooling_rate) * (ctx.temperature + (best_fitness - ctx.last_max_fitness))
  end

  defp initialize(problem, conf) do
    Enum.map(1..conf.population_size, fn _ -> problem.genotype() end)
  end

  defp select(population, conf) do
    nb_selected =
      case round(length(population) * conf.selection_rate) do
        n when rem(n, 2) == 0 -> n
        n -> n + 1
      end

    conf.selection_type.selection(population, nb_selected)
  end

  defp evaluate(population, problem) do
    Enum.map(population, fn chromosome ->
      %Chromosome{chromosome | fitness: problem.fitness(chromosome), age: chromosome.age + 1}
    end)
  end

  defp sort_population_by_fitness(population) do
    Enum.sort_by(population, fn chromosome -> chromosome.fitness end, :desc)
  end

  defp crossover(population, conf) do
    population
    |> chunk_every_two()
    |> Enum.reduce([], fn {parent1, parent2}, acc ->
      {child1, child2} = conf.crossover_type.crossover(parent1, parent2, conf.crossover_opts)

      [child1, child2 | acc]
    end)
  end

  defp chunk_every_two(population) do
    population
    |> Stream.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
  end

  defp mutation(population, conf) do
    Enum.map(population, fn chromosome ->
      if :rand.uniform() < conf.mutation_rate do
        conf.mutation_type.mutation(chromosome, conf.mutation_opts)
      else
        chromosome
      end
    end)
  end
end
