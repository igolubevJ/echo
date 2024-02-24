defmodule Echo do
  @spec start(pid()) :: {:ok, pid()}
  def start(from) do
    pid = spawn(fn ->
      loop(from)
    end)

    {:ok, pid}
  end

  @spec ping(pid()) :: any()
  def ping(pid) do
    send(pid, :ping)
    receive do
      response -> response
    end
  end

  defp loop(from) do
    receive do
      :ping -> send(from, {:pong, node()})
      _ -> send(from, {:error})
    end

    loop(from)
  end
end
