defmodule TwittexWeb.AvatarUploadLive do
  use TwittexWeb, :live_view
  alias Twittex.Accounts
  on_mount {TwittexWeb.UserAuth, :mount_current_user}

  @two_mb 2 * 1024 * 1024
  @allowed_types ~w(.jpg .jpeg .png)

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> allow_upload(:avatar, accept: @allowed_types, max_entries: 1, max_file_size: @two_mb)}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    [avatar] =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:twittex), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    Accounts.save_user_avatar!(socket.assigns.current_user, Path.basename(avatar))
    {:noreply, socket}
  end

  def upload_error(%{code: :too_large} = assigns) do
    ~H"""
    <.error>File too large. Max size is 2MB</.error>
    """
  end

  def upload_error(%{code: :not_accepted} = assigns) do
    ~H"""
    <.error>
      Filetype not allowed. Allowed types are <%= Enum.join(@allowed_types, ", ") %>
    </.error>
    """
  end
end
