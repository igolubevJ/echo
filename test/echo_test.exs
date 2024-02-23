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
      :pong -> assert(true)
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
end
