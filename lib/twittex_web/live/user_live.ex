defmodule TwittexWeb.UserLive do
  use TwittexWeb, :live_view
  import Phoenix.HTML.Tag, only: [img_tag: 2]

  import TwittexWeb.AvatarHelper
  alias Twittex.Accounts
  alias Twittex.Feed
  alias Twittex.Feed.Tweek

  on_mount {TwittexWeb.UserAuth, :mount_current_user}

  # def mount(%{"username" => username}, _session, socket) do
  #   user = Accounts.get_user_by_username!(username)
  #   tweeks = Feed.list_tweeks_for_user(user)
  #   form = Feed.change_tweek(%Tweek{}) |> to_form
  #   {:ok, assign(socket, form: form, tweeks: tweeks, user: user)}
  # end

  def mount(%{"username" => username}, _session, socket) do
    user = Accounts.get_user_by_username!(username)
    tweeks = Feed.list_tweeks_for_user(user)
    changeset = Feed.change_tweek(%Tweek{})
    form = Feed.change_tweek(%Tweek{}) |> to_form

    socket =
      socket
      |> assign(:user, user)
      |> assign_current_user_follows_user
      |> assign(:tweeks, tweeks)
      |> assign(:form, form)
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  defp assign_current_user_follows_user(socket) do
    follows? =
      socket.assigns.current_user &&
        Feed.follows?(socket.assigns.current_user, socket.assigns.user)

    assign(socket, :current_user_follows_user?, follows?)
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

  def handle_event("follow", %{"user-id" => user_id}, socket) do
    Feed.follow!(socket.assigns.current_user.id, user_id)
    {:noreply, assign(socket, :current_user_follows_user?, true)}
  end

  def handle_event("unfollow", %{"user-id" => user_id}, socket) do
    Feed.unfollow!(socket.assigns.current_user.id, user_id)
    {:noreply, assign(socket, :current_user_follows_user?, false)}
  end
end
