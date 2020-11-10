defmodule Genetic.Selection.Random do
  @behaviour Genetic.Selection

  @impl true
  def selection(population, selection_rate) do
    population
    |> Enum.shuffle()
    |> Enum.split(selection_rate)
  end
end
