defmodule Genetic.Selection do
  @callback selection(Enum.t(), number()) :: {Enum.t(), Enum.t()}
end
