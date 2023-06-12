defmodule Twittex.Feed.Follow do
  use Ecto.Schema
  import Ecto.Changeset

  schema "follows" do
    belongs_to :follower, Twittex.Accounts.User
    belongs_to :followed, Twittex.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [])
    |> validate_required([])
    |> cast(attrs, [:follower_id, :followed_id])
    |> unique_constraint([:follower_id, :followed_id])
  end
end
