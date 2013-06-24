Fabricator('card/text') do
  content { Faker::Lorem.sentence }
  title { Faker::Lorem.sentence }
  user
  board
end
