defmodule TurtleFw.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.Project.config()[:target]

  use Application

  alias TurtleFw.{
    Socket,
    TurtleChannel
  }

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: TurtleFw.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  # List all child processes to be supervised
  def children("host") do
    [
      Socket,
      {TurtleChannel, socket: Socket, topic: TurtleChannel.topic()}
    ]
  end

  def children(_target) do
    [
      Picam.Camera,
      Socket,
      {TurtleChannel, socket: Socket, topic: TurtleChannel.topic()},
      {Task, fn -> TurtleChannel.connect() end}
    ]
  end
end
