Fabricator('card/timestamp') do
  title     { Faker::Lorem.sentence }
  timestamp { DateTime.now.to_s }
  user
  board
  project   { nil }
end
