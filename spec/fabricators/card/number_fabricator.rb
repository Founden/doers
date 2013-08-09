Fabricator('card/number') do
  number     { rand(1.0..9999.999).to_f.round(3) }
  content    { Faker::Lorem.sentence }
  title      { Faker::Lorem.sentence }
  title_hint { Faker::Lorem.sentence }
  user
  board
  project    { nil }
  question   { Faker::Lorem.sentence }
  help       { Faker::Lorem.phrases(4).join("\n") }
end
