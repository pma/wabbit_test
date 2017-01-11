alias Experimental.GenStage

# GenStage Pipeline:
#   Producer -> Sink -> [RabbitMQ Broker] -> Source -> Consumer

defmodule WabbitTest.Producer do
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def init(counter) do
    {:producer, counter}
  end

  def handle_demand(demand, counter) when demand > 0 do
    events = Enum.to_list(counter..counter+demand-1)
    {:noreply, events, counter + demand}
  end
end
