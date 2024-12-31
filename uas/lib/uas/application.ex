defmodule Uas.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UasWeb.Telemetry,
      Uas.Repo,
      {DNSCluster, query: Application.get_env(:uas, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Uas.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Uas.Finch},
      # Start a worker by calling: Uas.Worker.start_link(arg)
      # {Uas.Worker, arg},
      # Start to serve requests, typically the last entry
      UasWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Uas.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UasWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
