# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     XQ.Archive.Repo.insert!(%XQ.Archive.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias XQ.Archive.Opening

XQ.Archive.Repo.insert!(
  %Opening{
    code: "A01",
    moves: [],
    name: "Advisor Opening"
  },
  on_conflict: {:replace_all_except, [:id, :inserted_at]},
  conflict_target: [:code]
)
