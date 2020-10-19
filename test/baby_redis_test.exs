defmodule BabyRedisTest do
  use ExUnit.Case
  doctest BabyRedis

  test "greets the world" do
    assert BabyRedis.hello() == :world
  end
end
