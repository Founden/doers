Fabricator(:card) do
  title { Faker::Lorem.sentence }
  user
  board
end
