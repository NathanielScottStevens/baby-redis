defmodule SerializerTest do
  use ExUnit.Case
  alias BabyRedis.Serializer

  describe "serialize" do
    test "strings" do
      assert {:ok, "+A String\r\n"} == Serializer.serialize("A String")
    end

    test "integers" do
      assert {:ok, ":555\r\n"} == Serializer.serialize(555)
    end

    test "list" do
      assert {:ok, "*2\r\n+hello\r\n:555\r\n"} == Serializer.serialize(["hello", 555])
    end

    test "unknown type returns error" do
      assert {:error, :unknown_type} == Serializer.serialize(:atom)
    end
  end

  describe "deserialize" do
    test "strings" do
      assert {:ok, "A String"} == Serializer.deserialize("+A String\r\n")
    end

    test "integers" do
      assert {:ok, 555} == Serializer.deserialize(":555\r\n")
    end

    test "list" do
      assert {:ok, ["hello", 555]} == Serializer.deserialize("*2\r\n+hello\r\n:555\r\n")
    end

    test "returns error if list has too few items" do
      assert {:error, :unmatched_items} ==
               Serializer.deserialize("*3\r\n+hello\r\n:555\r\n")
    end

    test "returns error if not an integer" do
      assert {:error, :not_an_integer} == Serializer.deserialize(":a_word\r\n")
    end

    test "returns error if a nonvalid type prefix" do
      assert {:error, :not_a_valid_type} == Serializer.deserialize("~a_word\r\n")
    end
  end
end
