alias XQ.Archive.{Opening, Repo}

now = DateTime.utc_now()

openings =
  Enum.map(
    [
      {"A01", "Advisor Opening"},
      {"B01", "Elephant Opening"},
      {"C01", "Folding Cannons Defense"},
      {"C02", "Palcorner Cannon Opening"},
      {"C03", "Cross Palace Cannon Opening"},
      {"C04", "Same Direction Cannon Opening"},
      {"C05", "Opposite Direction Cannon (Counter Cannon) Opening"},
      {"D01", "Central Cannon Opening"},
      {"D02", "Central Cannon - Single Horse Defense"},
      {"D03", "Central Cannon - Left 3-Step Tiger Defense"},
      {"D04", "Central Cannon - Sandwich Horses Defense"},
      {"D05", "5/8 Cannons - Sandwich Horses Defense"},
      {"D06", "5/6 Cannons - Sandwich Horses Defense"},
      {"D07", "5/7 Cannons - Sandwich Horses Defense"},
      {"D08", "Central Cannon, 8th File Horses - Screen Horses Defense"},
      {"D09", "Central Cannon, Ranked Chariot - Screen Horses Defense"},
      {"D10", "Central Cannon, River-Rank Chariot - Screen Horses Defense"},
      {"D11", "Central Cannon - Screen Horses Defense"},
      {"D12", "Central Cannon - Screen Horses Defense, 3/7 Soldier"},
      {"D13", "Central Cannon - Screen Horses Defense, 7th Soldier"},
      {"D14", "Central Cannon - Screen Horses Defense, RB Horse"},
      {"D16", "Central Cannon - Screen Horses Defense, Edge Cannon for Chariot Exchange"},
      {"D17", "5/6 Cannons - Screen Horses"},
      {"D18", "5/7 Cannons - Screen Horses"},
      {"D19", "Central Cannon, River-Rank Cannon - Screen Horses Defense"},
      {"D20", "5/8 Cannons - Screen Horses"},
      {"N02", "Horse Opening"},
      {"P01", "Edge Soldier Opening"},
      {"P02", "Soldier Opening"}
    ],
    fn {code, name} ->
      %{code: code, name: name, moves: [], inserted_at: now, updated_at: now}
    end
  )

IO.inspect(openings)

Repo.insert_all(
  Opening,
  openings,
  on_conflict: {:replace_all_except, [:id, :inserted_at]},
  conflict_target: [:code]
)
