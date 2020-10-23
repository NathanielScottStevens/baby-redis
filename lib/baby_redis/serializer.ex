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

  def serialize(data) when is_list(data) do
    length = Enum.count(data)

    # TODO handle errors in serializing items
    serialized_data = data |> Enum.map(&serialize!/1) |> Enum.join()

    {:ok, "*#{length}\r\n#{serialized_data}"}
  end

  def serialize(_data), do: {:error, :unknown_type}

  @spec serialize!(String.t()) :: String.t()
  def serialize!(data) do
    {:ok, serialized_data} = serialize(data)
    serialized_data
  end

  @doc """
    Deserializes data from redis protocol
  """
  @spec deserialize(String.t()) :: {:ok, String.t()} | {:error, atom()}
  def deserialize("+" <> data) when is_binary(data) do
    {:ok, String.trim(data)}
  end

  def deserialize(":" <> data) when is_binary(data) do
    value = String.trim(data)

    with {int, _} <- Integer.parse(value) do
      {:ok, int}
    else
      _ -> {:error, :not_an_integer}
    end
  end

  def deserialize("*" <> data) when is_binary(data) do
    [length | items] =
      data
      |> String.split("\r\n")
      |> Enum.map(&String.trim/1)
      |> Enum.reject(&(&1 == ""))

    # TODO handle errors in deserializing items
    deserialized_items = Enum.map(items, &deserialize!/1)
    {parsed_length, _} = Integer.parse(length)

    if parsed_length == Enum.count(deserialized_items) do
      {:ok, deserialized_items}
    else
      {:error, :unmatched_items}
    end
  end

  def deserialize(_data), do: {:error, :not_a_valid_type}

  @spec deserialize!(String.t()) :: String.t()
  def deserialize!(data) do
    {:ok, deserialized_data} = deserialize(data)
    deserialized_data
  end
end
