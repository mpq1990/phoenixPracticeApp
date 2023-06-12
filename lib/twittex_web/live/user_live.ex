defmodule TwittexWeb.UserLive do
  use TwittexWeb, :live_view
  import Phoenix.HTML.Tag, only: [img_tag: 2]
  import TwittexWeb.AvatarHelper

  alias Twittex.Accounts
  alias Twittex.Feed
  alias Twittex.Feed.Tweek

  on_mount {TwittexWeb.UserAuth, :mount_current_user}

  def mount(%{"username" => username}, _session, socket) do
    user = Accounts.get_user_by_username!(username)
    tweeks = Feed.list_tweeks_for_user(user)
    form = Feed.change_tweek(%Tweek{}) |> to_form
    {:ok, assign(socket, form: form, tweeks: tweeks, user: user)}
  end

  def handle_event("save", %{"tweek" => tweek_params}, socket) do
    current_user = socket.assigns.current_user

    if is_nil(current_user), do: raise("not logged in")

    case Feed.create_tweek_for_user(current_user, tweek_params) do
      {:ok, tweek} ->
        {:noreply, update(socket, :tweeks, &[tweek | &1])}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
