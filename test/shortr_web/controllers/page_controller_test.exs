defmodule ShortrWeb.PageControllerTest do
  use ShortrWeb.ConnCase
  import ShortrWeb.PageView, only: [link_url: 1]

  @create_attrs %{url: "https://example.com"}
  @invalid_create_attrs %{url: "asdf"}

  test "GET /", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :index))
    assert html_response(conn, 200) =~ "Shortr"
  end

  describe "create link" do
    test "renders success when valid", %{conn: conn} do
      conn = post(conn, Routes.page_path(conn, :create), link: @create_attrs)

      %{assigns: %{link: link}} = conn

      assert html_response(conn, 200) =~ link_url(link)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.page_path(conn, :create), link: @invalid_create_attrs)

      assert html_response(conn, 200) =~ "Invalid URL!"
    end
  end

  describe "redirects" do
    test "link redirect", %{conn: conn} do
      %{assigns: %{link: link}} = post(conn, Routes.page_path(conn, :create), link: @create_attrs)

      conn = get(conn, link_url(link))
      assert redirected_to(conn) =~ link.url
    end

    test "visiting link increments hits", %{conn: conn} do
      %{assigns: %{link: link}} = post(conn, Routes.page_path(conn, :create), link: @create_attrs)

      assert link.hits == 0

      get(conn, link_url(link))

      %{hits: hits} = Shortr.Links.get_link!(link.id)

      assert hits == 1
    end

    test "visiting invalid link renders 404", %{conn: conn} do
      conn = get(conn, "/asdf")
      assert html_response(conn, 404) =~ "Link not found!"
    end
  end

  describe "stats" do
    test "renders stats page", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :stats))
      assert html_response(conn, :ok) =~ "table-dark"
    end

    test "allows exporting", %{conn: conn} do
      conn = get(conn, Routes.page_path(conn, :export))
      assert response_content_type(conn, :csv)
    end
  end

end
