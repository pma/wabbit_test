defmodule WabbitTest.Source do
  use Wabbit.GenStage

  def start_link() do
    Wabbit.GenStage.start_link(__MODULE__, WabbitTest.Connection, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:producer, 0}
  end

  def handle_channel_opened(chan, state) do
    # Declare exchange, queue, bindings, etc...
    {:ok, %{queue: queue}} = Wabbit.Queue.declare(chan, "command_handler", durable: true)
    # Set consume queue and options
    {:ok, queue, state, prefetch_count: 100, no_ack: true}
  end

  def handle_decode(payload, _meta, state) do
    case Integer.parse(payload) do
      {n, ""} -> {:ok, n, state + 1}
      _       -> {:error, :invalid_message, state}
    end
  end
end
