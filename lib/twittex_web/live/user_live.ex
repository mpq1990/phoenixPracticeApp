defmodule TwittexWeb.UserLive do
  use TwittexWeb, :live_view
  import Phoenix.HTML.Tag, only: [img_tag: 2]

  alias Twittex.Accounts

  def mount(%{"username" => username}, _session, socket) do
    user = Accounts.get_user_by_username!(username)
    {:ok, assign(socket, :user, user)}
  end
end
