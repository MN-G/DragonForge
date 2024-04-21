defmodule Campaignhub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CampaignhubWeb.Telemetry,
      Campaignhub.Repo,
      {DNSCluster, query: Application.get_env(:campaignhub, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Campaignhub.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Campaignhub.Finch},
      # Start a worker by calling: Campaignhub.Worker.start_link(arg)
      # {Campaignhub.Worker, arg},
      # Start to serve requests, typically the last entry
      CampaignhubWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Campaignhub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CampaignhubWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
