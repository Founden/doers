Fabricator('card/paragraph') do
  content { Faker::HTMLIpsum.fancy_string }
  title   { Faker::Lorem.sentence }
  user
  board
  project { nil }
end
