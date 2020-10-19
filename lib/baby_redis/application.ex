defmodule BabyRedis.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: BabyRedis.TCPSupervisor},
      Supervisor.child_spec({Task, fn -> BabyRedis.TCPConnection.accept(1234) end}, restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: BabyRedis.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
