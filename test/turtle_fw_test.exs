defmodule TurtleFwTest do
  use ExUnit.Case
  doctest TurtleFw

  test "greets the world" do
    assert TurtleFw.hello() == :world
  end
end
