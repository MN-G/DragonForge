defmodule Campaignhub.Repo do
  use Ecto.Repo,
    otp_app: :campaignhub,
    adapter: Ecto.Adapters.Postgres
end
