defmodule ShortrWeb.PageController do
  use ShortrWeb, :controller
  alias Shortr.Links
  alias Shortr.Links.Link
  alias Shortr.Repo

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
    conn =
      conn
      |> put_resp_content_type("text/csv")
      |> put_resp_header("content-disposition", ~s(attachment; filename="export.csv"))
      |> send_chunked(:ok)

    {:ok, conn} =
      Repo.transaction(fn ->
        Links.export_links()
        |> Enum.reduce_while(conn, fn data, conn ->
          case chunk(conn, data) do
            {:ok, conn} -> {:cont, conn}
            {:error, :closed} -> {:halt, conn}
          end
        end)
      end)

      conn
  end

  defp do_redirect(%Link{url: url}, conn), do: redirect(conn, external: url)
end
