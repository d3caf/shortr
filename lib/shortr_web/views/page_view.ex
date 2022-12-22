defmodule ShortrWeb.PageView do
  use ShortrWeb, :view
  alias Shortr.Links.Link

  def link_url(%Link{slug: slug}), do: "#{ShortrWeb.Endpoint.url()}/#{slug}"
end
