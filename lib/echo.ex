defmodule Echo do
  @spec start(pid()) :: {:ok, pid()}
  def start(from) do
    pid = spawn(fn ->
      loop(from)
    end)

    {:ok, pid}
  end

  defp loop(from) do
    receive do
      :ping -> send(from, :pong)
    end

    loop(from)
  end
end
