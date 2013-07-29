Fabricator('card/link') do
  content { Faker::Internet.uri(Card::Link::ALLOWED_SCHEMES.sample) }
  title   { Faker::Lorem.sentence }
  user
  board
  project { nil }
end
