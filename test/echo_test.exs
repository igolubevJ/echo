defmodule EchoTest do
  use ExUnit.Case
  doctest Echo

  test "should get the result when sending :ping" do
    {:ok, pid} = Echo.start(self())

    send(pid, :ping)

    receive do
      {response, node_name} ->
        assert response == :pong
        assert node_name in [node() | Node.list()]
      _ ->
        assert(false)
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

    assert_receive :error, 1_000
    refute_receive {:ok, _}, 1_000
  end

  test "process must remain running after sending error message" do
    {:ok, pid} = Echo.start(self())
    send(pid, :wtf)
    assert(Process.alive?(pid))
  end

  test "should get the result when cal Echo API ping command" do
    {:ok, pid} = Echo.start(self())
    {response, node_name} = Echo.ping(pid)

    assert response == :pong
    assert node_name in [node() | Node.list()]
  end
end
