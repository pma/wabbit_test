defmodule WabbitTest.Sink do
  use Wabbit.GenStage
  alias WabbitTest.Producer

  def start_link() do
    Wabbit.GenStage.start_link(__MODULE__, WabbitTest.Connection, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:consumer, 0, max_unconfirmed: 1000, subscribe_to: [Producer]}
  end

  def handle_channel_opened(chan, state) do
    # Declare exchange, queue, bindings, etc...
    {:ok, %{queue: queue}} = Wabbit.Queue.declare(chan, "command_handler", durable: true)
    # Set default publish options: use default exchange and route directly to queue
    {:ok, state, exchange: "", routing_key: queue, persistent: true}
  end

  def handle_encode(event, state) do
    # Encode event to binary payload and override default publish options
    payload = Integer.to_string(event)
    publish_opts = [timestamp: :os.system_time()]
    {:ok, payload, state + 1, publish_opts}
  end
end
