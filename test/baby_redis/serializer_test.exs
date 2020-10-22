defmodule SerializerTest do
  use ExUnit.Case
  alias BabyRedis.Serializer

  describe "serialize" do
    test "serializes strings" do
      assert {:ok, "+A String\r\n"} == Serializer.serialize("A String")
    end

    test "serializes integers" do
      assert {:ok, ":555\r\n"} == Serializer.serialize(555)
    end
  end
end
