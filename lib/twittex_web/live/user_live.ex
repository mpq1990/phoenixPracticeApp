defmodule TwittexWeb.UserLive do
  use TwittexWeb, :live_view
  import Phoenix.HTML.Tag, only: [img_tag: 2]

  alias Twittex.Accounts
  alias Twittex.Feed

  def mount(%{"username" => username}, _session, socket) do
    user = Accounts.get_user_by_username!(username)
    tweeks = Feed.list_tweeks_for_user(user)
    {:ok, assign(socket, tweeks: tweeks, user: user)}
  end
end
