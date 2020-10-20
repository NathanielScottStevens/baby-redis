defmodule BabyRedis.Server do
  require Logger
  alias BabyRedis.Serializer

  def accept(port) do
    opts = [:binary, packet: 0, active: false, reuseaddr: true]
    {:ok, socket} = :gen_tcp.listen(port, opts)

    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)

    {:ok, pid} =
      Task.Supervisor.start_child(BabyRedis.TCPSupervisor, fn ->
        serve(client)
      end)

    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    Logger.info("Waiting to recieve data")

    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        Logger.info("Received data: #{data}")

        # {:ok, cmd} = Serializer.deserialize(data)
        # {:ok, result} Engine.execute(cmd)
        # :ok = :gen_tcp.send(socket, result)

        :ok = :gen_tcp.send(socket, "Hey!\n")
        serve(socket)

      {:error, err} ->
        Logger.info("Closing socket: #{err}")
    end
  end
end
