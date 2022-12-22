defmodule Shortr.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  @url_regex ~r/^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$/

  schema "links" do
    field :hits, :integer
    field :slug, :string
    field :url, :string
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :slug, :hits])
    |> validate_url()
    |> set_slug_if_nil()
    |> validate_required([:url, :slug])
  end

  defp validate_url(changeset), do: validate_format(changeset, :url, @url_regex)

  defp set_slug_if_nil(changeset) do
    slug = get_field(changeset, :slug)

    if is_nil(slug) do
      put_change(changeset, :slug, generate_slug())
    else
      changeset
    end
  end

  defp generate_slug() do
    :crypto.strong_rand_bytes(6) |> Base.url_encode64() |> binary_part(0, 6)
  end
end
