Fabricator('card/phrase') do
  content { Faker::Lorem.sentence }
  title   { Faker::Lorem.sentence }
  user
  board
  project { nil }
end
