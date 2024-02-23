defmodule Echo do
  def start(from) do
    pid = spawn(fn ->
      loop(from)
    end)

    {:ok, pid}
  end

  defp loop(_from) do
    raise "Error -> not implemented"
  end
end
