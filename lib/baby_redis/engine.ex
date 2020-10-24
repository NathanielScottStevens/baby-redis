defmodule BabyRedis.Engine do
  use GenServer
  require Logger

  @type data() :: String.t()
  @type command() :: list()

  @initial_state %{data: %{}}

  def start_link(_args) do
    GenServer.start_link(__MODULE__, @initial_state, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:execute, [cmd | data]}, _from, state) do
    {result, new_data} = execute_cmd(String.downcase(cmd), data, state[:data])
    {:reply, result, %{state | data: new_data}}
  end

  defp execute_cmd("set", [key, value], data) do
    Logger.info("Setting #{key} to #{value}")
    {nil, Map.put(data, key, value)}
  end

  defp execute_cmd("get", [key], data) do
    Logger.info("Getting value for #{key}")
    {data[key], data}
  end

  defp execute_cmd(_cmd, _values, data), do: {:unknown_command, data}

  @doc "Executes command for datastore engine"
  @spec execute(command()) :: nil | String.t() | integer()
  def execute(command) do
    GenServer.call(__MODULE__, {:execute, command})
  end
end
