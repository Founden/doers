Fabricator('card/link') do
  url        { Faker::Internet.uri(Card::Link::ALLOWED_SCHEMES.sample) }
  content    { Faker::Lorem.paragraph }
  title      { Faker::Lorem.sentence }
  title_hint { Faker::Lorem.sentence }
  user
  board
  project    { nil }
  question   { Faker::Lorem.sentence }
  help       { Faker::Lorem.phrases(4).join("\n") }
end
