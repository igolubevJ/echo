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

  @doc """
  The function starts the echo process.
  The input takes the pid of the process that will receive responses
  from the echo process.

  The function returns tuple `{:ok, pid}`. Where is the `pid` is identificator of the
  echo process.

  #### Example
      iex> {:ok, pid} = Echo.start(self())
      {:ok, pid}
  """
  @spec start(pid()) :: {:ok, pid()}
  def start(from) do
    pid = spawn(fn ->
      loop(from)
    end)

    {:ok, pid}
  end

  @doc """
  Function for interacting with the echo process.
  The function accepts the echo process's pid and returns the response
  from the process echo.

  The response is a tuple containing a `:pong` atom and
  atom of the node on which this Echo process is running.

  #### Example
      iex> {:ok, pid} = Echo.start(self())
      {:ok, pid}
      iex> Echo.ping(pid)
      {:pong, :nonode@nohost}
  """
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
