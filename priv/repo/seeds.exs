# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Twittex.Repo.insert!(%Twittex.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Twittex.Repo
alias Twittex.Accounts
alias Twittex.Feed.Tweek

users =
  for name <- ~w(bill elon jeff mark) do
    username = String.capitalize(name)
    email = name <> "@phoenixonrails.com"
    password = "password1234"
    {:ok, user} = Accounts.register_user(%{username: username, email: email, password: password})
    Accounts.save_user_avatar!(user, name <> ".png")
    user
  end

{now, _} = NaiveDateTime.utc_now() |> NaiveDateTime.to_gregorian_seconds()

for _ <- 1..100 do
  Repo.insert!(%Tweek{
    content: Faker.Lorem.sentence(),
    user_id: Enum.random(users).id,
    inserted_at: NaiveDateTime.from_gregorian_seconds(now - :rand.uniform(30 * 24 * 60 * 60))
  })
end
