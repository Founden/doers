Fabricator(:card) do
  transient  :public_board
  title      { |attrs| Faker::Lorem.sentence unless attrs[:public_board] }
  title_hint { Faker::Lorem.sentence }
  user
  board
  style      { Card::STYLES.sample }
  question   { Faker::Lorem.sentence }
  help       { Faker::Lorem.phrases(4).join("\n") }
end
