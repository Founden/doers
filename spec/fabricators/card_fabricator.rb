Fabricator(:card) do
  title { Faker::Lorem.sentence }
  user
  board
  style { Card::STYLES.sample }
end
