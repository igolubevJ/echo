defmodule Echo do
  def start() do
    pid = spawn(&loop/0)

    {:ok, pid}
  end

  defp loop() do
    raise "Error -> not implemented"
  end
end
