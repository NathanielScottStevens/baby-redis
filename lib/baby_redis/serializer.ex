defmodule BabyRedis.Serializer do
  require Logger

  @doc """
    Serializes data to redis protocol
  """
  @spec serialize(String.t()) :: {:ok | :error, String.t()}
  def serialize(data) when is_binary(data) do
    {:ok, "+#{data}\r\n"}
  end

  def serialize(data) when is_integer(data) do
    {:ok, ":#{data}\r\n"}
  end

  @doc """
    Deserializes data from redis protocol
  """
  @spec deserialize(String.t()) :: {:ok | :error, String.t()}
  def deserialize(data) do
  end
end
