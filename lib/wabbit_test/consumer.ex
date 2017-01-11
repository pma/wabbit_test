alias Experimental.GenStage

defmodule WabbitTest.Consumer do
  use GenStage
  alias WabbitTest.Source

  def start_link() do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [Source]}
  end

  def handle_events(events, _from, state) do
    for {event, meta} <- events do
      IO.inspect {event, meta}
    end
    {:noreply, [], state}
  end
end
