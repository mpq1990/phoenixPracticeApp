defmodule TwittexWeb.AvatarHelper do
  alias Twittex.Accounts.User

  def avatar_path(%User{} = user) do
    if is_nil(user.avatar) do
      "/images/default_avatar.png"
    else
      "/uploads/#{user.avatar}"
    end
  end
end
