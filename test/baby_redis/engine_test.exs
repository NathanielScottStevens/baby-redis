defmodule EngineTest do
  use ExUnit.Case
  alias BabyRedis.Engine

  setup do
    {:ok, subject} = start_supervised(Engine)
    [subject: subject]
  end

  describe "execute" do
    test "set and get", context do
      nil = Engine.execute(["SET", "key", 5])
      actual = Engine.execute(["GET", "key"])

      assert actual == 5
    end
  end
end
