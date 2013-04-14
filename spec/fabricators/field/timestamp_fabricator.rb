Fabricator('field/timestamp') do
  title     { Faker::Lorem.sentence }
  timestamp { DateTime.now.to_s }
  user
  project
end
