defmodule EchoTest do
  use ExUnit.Case
  doctest Echo

  test "we can run the echo process" do
    {:ok , pid} = Echo.start()
    assert(is_pid(pid))
  end
end
