defmodule Shortr.Repo do
  use Ecto.Repo,
    otp_app: :shortr,
    adapter: Ecto.Adapters.Postgres
end
