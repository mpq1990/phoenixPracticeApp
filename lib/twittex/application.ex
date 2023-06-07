defmodule Twittex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TwittexWeb.Telemetry,
      # Start the Ecto repository
      Twittex.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Twittex.PubSub},
      # Start Finch
      {Finch, name: Twittex.Finch},
      # Start the Endpoint (http/https)
      TwittexWeb.Endpoint
      # Start a worker by calling: Twittex.Worker.start_link(arg)
      # {Twittex.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Twittex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TwittexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
