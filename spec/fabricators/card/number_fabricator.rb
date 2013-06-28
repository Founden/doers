Fabricator('card/number') do
  content { rand(1.0..9999.999) }
  title { Faker::Lorem.sentence }
  user
  board
end
