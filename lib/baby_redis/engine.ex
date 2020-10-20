defmodule BabyRedis.Engine do
  use GenServer
  require Logger

  @type data() :: String.t()
  @type command() :: {atom(), data()}

  @initial_state [data: %{}]

  def start_link(_args) do
    GenServer.start_link(__MODULE__, @initial_state, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  @doc "Executes command for datastore engine"
  @spec execute(command()) :: {:ok | :error, String.t()}
  def execute(command) do
  end
end
