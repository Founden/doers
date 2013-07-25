Fabricator('card/timestamp') do
  title     { Faker::Lorem.sentence }
  content   { DateTime.now.to_s }
  user
  board
  project   { nil }
end
