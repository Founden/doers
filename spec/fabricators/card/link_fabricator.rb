Fabricator('card/link') do
  style      { Card::STYLES.sample }
  title      { Faker::Lorem.sentence }
  user
  board      { |attrs| Fabricate(:board, :user => attrs[:user]) }
  topic      { |attrs|
    Fabricate(:topic, :user => attrs[:user], :board => attrs[:board]) }

  url        { Faker::Internet.uri(Card::Link::ALLOWED_SCHEMES.sample) }
  content    { Faker::Lorem.paragraph }
end
