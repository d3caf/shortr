defmodule Shortr.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Shortr.Links` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        hits: 42,
        slug: "slug",
        url: "https://example.com"
      })
      |> Shortr.Links.create_link()

    link
  end
end
