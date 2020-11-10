size = 1000

population =
  for _ <- 1..1000 do
    for _ <- 1..size do
      Enum.random(0..1)
    end
  end

evaluate = fn population ->
  Enum.sort_by(population, &Enum.sum(&1), &>=/2)
end

selection = fn population ->
  population
  |> Stream.chunk_every(2)
  |> Enum.map(&List.to_tuple(&1))
end

crossover = fn population ->
  Enum.reduce(population, [], fn {p1, p2}, acc ->
    cx_point = :rand.uniform(size)

    {{h1, t1}, {h2, t2}} = {
      Enum.split(p1, cx_point),
      Enum.split(p2, cx_point)
    }

    [h1 ++ t2 | [h2 ++ t1 | acc]]
  end)
end

mutation = fn population ->
  Enum.map(
    population,
    fn chromosome ->
      if :rand.uniform() < 0.05 do
        Enum.shuffle(chromosome)
      else
        chromosome
      end
    end
  )
end

algorithm = fn population, algorithm ->
  best_chromosome = Enum.max_by(population, &Enum.sum(&1))
  best_chromosome_sum = Enum.sum(best_chromosome)

  IO.write("\rCurrent best: #{best_chromosome_sum}")

  if best_chromosome_sum == size do
    best_chromosome
  else
    population
    |> evaluate.()
    |> selection.()
    |> crossover.()
    |> mutation.()
    |> algorithm.(algorithm)
  end
end

solution = algorithm.(population, algorithm)

IO.write("\nAnswer is #{inspect(solution)}")
