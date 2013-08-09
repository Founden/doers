Fabricator(:card) do
  title      { Faker::Lorem.sentence }
  title_hint { Faker::Lorem.sentence }
  user
  board
  style      { Card::STYLES.sample }
  question   { Faker::Lorem.sentence }
  help       { Faker::Lorem.phrases(4).join("\n") }
end
