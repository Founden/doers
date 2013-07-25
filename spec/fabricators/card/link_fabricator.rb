Fabricator('card/link') do
  url     { Faker::Internet.uri(Card::Link::ALLOWED_SCHEMES.sample) }
  content { Faker::Lorem.paragraph }
  title   { Faker::Lorem.sentence }
  user
  board
  project { nil }
end
