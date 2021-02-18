alias XQ.Archive.{Game, Opening, Repo}

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
    fn {id, name} ->
      %{id: id, name: name, moves: [], inserted_at: now, updated_at: now}
    end
  )

IO.inspect(openings)

Repo.insert_all(
  Opening,
  openings,
  on_conflict: {:replace_all_except, [:inserted_at]},
  conflict_target: [:id]
)

games =
  Enum.map(
    [
      %{
        data: %{
          "Last Modify" => "2011/10/30 12:52:26",
          "Hits" => "5385",
          "Round" => "Round 11",
          "game index" => "34561"
        },
        result: "Red DRAW",
        opening_id: "A01",
        source_id: "34561",
        source: "01xq",
        event: "2011 China Individual Xiangqi Championship Men",
        date:
          (fn raw_date ->
             {:ok, date, _} = DateTime.from_iso8601(raw_date)
             date
           end).("2011-10-25T00:00:00+0000"),
        red_club: "HuBei",
        red_player: "Li XueSong",
        black_club: "BeiJing",
        black_player: "Sun Bo",
        move_count: 59,
        moves: [
          "A4+5",
          "p7+1",
          "C2=3",
          "b7+5",
          "N2+1",
          "n8+7",
          "R1=2",
          "r9=8",
          "C8=4",
          "n2+1",
          "N8+7",
          "r1=2",
          "R9=8",
          "c8+4",
          "R8+4",
          "c2=3",
          "R8=4",
          "r2+1",
          "B7+5",
          "r2=8",
          "P7+1",
          "c8+1",
          "P1+1",
          "p1+1",
          "P3+1",
          "c8=6",
          "R2+8",
          "r8+1",
          "A5+4",
          "r8+3",
          "N7+6",
          "c3=2",
          "A6+5",
          "c2+3",
          "P3+1",
          "r8=7",
          "B5+3",
          "r7=4",
          "C3+5",
          "r4+1",
          "R4=6",
          "c2=4",
          "+B-5",
          "n1+2",
          "C3-4",
          "p1+1",
          "C3=1",
          "n2+1",
          "C1=9",
          "p1+1",
          "N1+2",
          "c4=9",
          "N2+1",
          "p1=2",
          "P5+1",
          "p2=3",
          "N1+3",
          "+p=4",
          "N3-5"
        ]
      }
    ],
    fn game -> Map.merge(game, %{inserted_at: now, updated_at: now}) end
  )

Repo.insert_all(
  Game,
  games,
  on_conflict: {:replace_all_except, [:id, :inserted_at]},
  conflict_target: [:source_id]
)
