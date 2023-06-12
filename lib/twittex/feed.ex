defmodule Twittex.Feed do
  alias Twittex.Accounts.User
  alias Twittex.Feed.Tweek
  alias Twittex.Repo

  import Ecto.Query

  def list_tweeks_for_user(%User{} = user) do
    user
    |> Ecto.assoc(:tweeks)
    |> order_by([m], desc: m.inserted_at, desc: m.id)
    |> preload(:user)
    |> Repo.all()
  end

  def create_tweek_for_user(%User{} = user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:tweeks)
    |> Tweek.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, tweek} -> {:ok, Repo.preload(tweek, :user)}
      other -> other
    end
  end

  def change_tweek(%Tweek{} = tweek, attrs \\ %{}) do
    Tweek.changeset(tweek, attrs)
  end
end
