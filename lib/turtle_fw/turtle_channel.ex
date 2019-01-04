defmodule TurtleFw.TurtleChannel do
  use PhoenixChannelClient
  require Logger
  @name Application.get_env(:turtle_fw, __MODULE__, [])[:turtle_name]

  def topic do
    "turtle:" <> @name
  end

  def connect do
    join()
    push("stream", %{image: image()})
  end

  def handle_in("after_connect", _, %{socket: socket} = state) do
    push = socket.push(state.topic, "stream", %{image: image()})
    timer = :erlang.start_timer(5000, self(), push)
    {:noreply, %{state | pushes: [{timer, push} | state.pushes]}}
  end

  def handle_in(event, payload, state) do
    IO.inspect(event, label: "event")
    IO.inspect(payload, label: "payload")
    {:noreply, state}
  end

  def handle_reply({:ok, "turtle:" <> @name, _, _}, %{socket: socket} = state) do
    push = socket.push(state.topic, "stream", %{image: image()})
    timer = :erlang.start_timer(5000, self(), push)
    {:noreply, %{state | pushes: [{timer, push} | state.pushes]}}
  end

  def handle_reply(reply, state) do
    IO.inspect(reply, label: "reply")
    {:noreply, state}
  end

  def handle_close(_payload, state) do
    Process.send_after(self(), :rejoin, 5_000)
    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def image do
    Picam.next_frame()
    |> Base.encode64()
  end
end
