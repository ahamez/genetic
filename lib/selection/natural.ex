defmodule Genetic.Selection.Natural do
  @behaviour Genetic.Selection

  @impl true
  def selection(population, selection_rate) do
    Enum.split(population, selection_rate)
  end
end
