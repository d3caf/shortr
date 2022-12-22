defmodule Shortr.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false
  alias Shortr.Repo

  alias Shortr.Links.Link

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links do
    query = from l in Link, order_by: [desc: :hits]
    Repo.all(query)
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link!(id), do: Repo.get!(Link, id)

  def get_link_by_slug(slug), do: Repo.get_by(Link, slug: slug)

  def add_hit(%Link{hits: hits} = link) do
    {:ok, link} =
      link
      |> update_link(%{hits: hits + 1})

    link
  end

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{data: %Link{}}

  """
  def change_link(%Link{} = link, attrs \\ %{}) do
    Link.changeset(link, attrs)
  end

  def export_links() do
    columns = ~w(url slug hits)
    query = """
    COPY (
      SELECT #{Enum.join(columns, ",")}
      FROM links
      ORDER BY hits DESC
    ) to STDOUT WITH CSV DELIMITER ',';
    """

    csv_header = [Enum.join(columns, ","), "\n"]

    Ecto.Adapters.SQL.stream(Repo, query, [], max_rows: 500)
    |> Stream.map(&(&1.rows))
    |> (fn stream -> Stream.concat(csv_header, stream) end).()
  end
end
