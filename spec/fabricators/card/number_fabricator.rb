Fabricator('card/number') do
  number  { rand(1.0..9999.999).to_f.round(3) }
  content { Faker::Lorem.sentence }
  title   { Faker::Lorem.sentence }
  user
  board
  project { nil }
end
