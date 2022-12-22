defmodule ShortrWeb.PageController do
  use ShortrWeb, :controller
  alias Shortr.Links
  alias Shortr.Links.Link

  def index(conn, _params) do
    changeset = Links.change_link(%Link{})
    render(conn, "index.html", changeset: changeset)
  end

  def create(conn, %{"link" => link_params}) do
    case Links.create_link(link_params) do
      {:ok, link} ->
        render(conn, "success.html", link: link)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end

  def show(conn, %{"slug" => slug}) do
    case Links.get_link_by_slug(slug) do
      nil ->
        conn |> put_status(:not_found) |> render("404.html")

      link ->
        Links.add_hit(link)
        |> do_redirect(conn)
    end
  end

  def stats(conn, _params) do
    links = Links.list_links()

    render(conn, "stats.html", links: links)
  end

  def export(conn, _params) do
  end

  defp do_redirect(%Link{url: url}, conn), do: redirect(conn, external: url)
end
