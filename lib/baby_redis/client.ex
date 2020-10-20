defmodule BabyRedis.Client do
  use GenServer
  require Logger

  @initial_state %{socket: nil}

  def start_link(_args) do
    GenServer.start_link(__MODULE__, @initial_state, name: __MODULE__)
  end

  def init(state) do
    opts = [:binary, active: false]
    {:ok, socket} = :gen_tcp.connect('localhost', 1234, opts)
    {:ok, %{state | socket: socket}}
  end

  def handle_call({:command, cmd}, from, %{socket: socket} = state) do
    Logger.info("Client sending command: #{cmd}")
    :ok = :gen_tcp.send(socket, cmd)

    {:ok, msg} = :gen_tcp.recv(socket, 0)
    Logger.info("Client received message: #{msg}")

    {:reply, msg, state}
  end

  def command(cmd) do
    GenServer.call(__MODULE__, {:command, cmd})
  end
end
