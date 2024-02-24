defmodule EchoTest do
  use ExUnit.Case
  doctest Echo

  test "we can run the echo process" do
    {:ok , pid} = Echo.start(self())
    assert(is_pid(pid))
  end

  test "should get the result when sending :ping" do
    {:ok, pid} = Echo.start(self())

    send(pid, :ping)

    receive do
      {response, node_name} ->
        assert(is_atom(response))
        assert(response == :pong)

        assert(is_atom(node_name))
        assert(String.contains?(to_string(node_name), "@"))
      _ -> assert(false)
    after
      1_000 -> assert(false)
    end
  end

  test "process must remain running after sending the message" do
    {:ok, pid} = Echo.start(self())
    send(pid, :ping)
    assert(Process.alive?(pid))
  end

  test "should get the error when sending other message" do
    {:ok, pid} = Echo.start(self())

    send(pid, :some)

    receive do
      {:ok, :pong} -> assert(false)
      {:error} -> assert(true)
      _ -> assert(false)
    after
      1_000 -> assert(false)
    end
  end

  test "process must remain running after sending error message" do
    {:ok, pid} = Echo.start(self())
    send(pid, :wtf)
    assert(Process.alive?(pid))
  end

  test "should get the result when cal Echo API ping command" do
    {:ok, pid} = Echo.start(self())
    {response, node_name} = Echo.ping(pid)

    assert(is_atom(response))
    assert(response == :pong)
    assert(is_atom(node_name))
    assert(String.contains?(to_string(node_name), "@"))
  end
end
