defmodule TwittexWeb.TweekController do
  use TwittexWeb, :controller

  alias Twittex.Feed

  def feed(conn, params) do
    tweeks = Feed.list_feed_for_user(conn.assigns.current_user)
    render(conn, :feed, tweeks: tweeks)
  end
end
