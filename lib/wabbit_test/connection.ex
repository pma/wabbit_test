defmodule WabbitTest.Connection do
  def start_link do
    Wabbit.Connection.start_link(host: "localhost", port: 5672, username: "guest", password: "guest", name: __MODULE__)
  end
end
