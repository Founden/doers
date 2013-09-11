Fabricator('card/link') do
  transient  :public_board
  title      { |attrs| Faker::Lorem.sentence unless attrs[:public_board] }
  url        { Faker::Internet.uri(Card::Link::ALLOWED_SCHEMES.sample) }
  content    { Faker::Lorem.paragraph }
  title_hint { Faker::Lorem.sentence }
  user
  board
  project    { nil }
  question   { Faker::Lorem.sentence }
  help       { Faker::Lorem.phrases(4).join("\n") }
end
