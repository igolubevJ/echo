defmodule Echo do
  @moduledoc """
  This model creates an echo process.
  You can create multiple echo processes in your application.

  To create an echo process, simply call the start function and pass the pid
  of the process that will receive responses from the echo process.
  To interact with this process, you can use the `Echo.ping/1` function or send
  a message using the `Kernel.send/2`.

  #### Examples
      iex> {:ok, pid} = Echo.start(self())
      {:ok, pid}
      iex> Echo.ping(pid)
      {:pong, :nonode@nohost}

  If you send an erroneous message, Echo return error tuple `{:error}`.

  #### Examples
      iex> {:ok, pid} = Echo.start(self())
      {:ok, pid}
      iex> send(pid, :some)
      :some
      iex> receive do msg -> msg end
      {:error}
  """
  @spec start(pid()) :: {:ok, pid()}
  def start(from) do
    pid = spawn(fn ->
      loop(from)
    end)

    {:ok, pid}
  end

  @spec ping(pid()) :: {:pong, atom()} | {:error}
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
