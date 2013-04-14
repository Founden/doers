Fabricator('field/text') do
  content { Faker::Lorem.sentence }
  user
  project
end
