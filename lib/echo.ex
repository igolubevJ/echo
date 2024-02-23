defmodule Echo do
  def start() do
    pid = spawn(fn ->
      raise "Error -> not implemented"
    end)

    {:ok, pid}
  end
end
