defmodule Shortr.LinksTest do
  use Shortr.DataCase

  alias Shortr.Links

  describe "links" do
    alias Shortr.Links.Link

    import Shortr.LinksFixtures

    @invalid_attrs %{hits: nil, slug: nil, url: nil}

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert Links.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Links.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      valid_attrs = %{url: "https://google.com"}

      assert {:ok, %Link{} = link} = Links.create_link(valid_attrs)
      assert link.hits == 0
      assert not is_nil(link.slug)
      assert link.url == "https://google.com"
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()
      update_attrs = %{hits: 43, slug: "slug", url: "https://test.com"}

      assert {:ok, %Link{} = link} = Links.update_link(link, update_attrs)
      assert link.hits == 43
      assert link.slug == "slug"
      assert link.url == "https://test.com"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Links.update_link(link, @invalid_attrs)
      assert link == Links.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Links.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Links.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Links.change_link(link)
    end
  end
end
