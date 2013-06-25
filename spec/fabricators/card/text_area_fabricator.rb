Fabricator('card/text_area') do
  content { Faker::HTMLIpsum.fancy_string }
  title { Faker::Lorem.sentence }
  user
  board
end
