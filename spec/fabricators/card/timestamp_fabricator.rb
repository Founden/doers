Fabricator('card/timestamp') do
  title      { Faker::Lorem.sentence }
  title_hint { Faker::Lorem.sentence }
  content    { DateTime.now.to_s }
  user
  board
  project    { nil }
  question   { Faker::Lorem.sentence }
  help       { Faker::Lorem.phrases(4).join("\n") }
end
