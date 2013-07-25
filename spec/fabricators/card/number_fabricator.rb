Fabricator('card/number') do
  content { rand(1.0..9999.999).to_f.round(3) }
  title   { Faker::Lorem.sentence }
  user
  board
  project { nil }
end
