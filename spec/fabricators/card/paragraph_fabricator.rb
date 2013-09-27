Fabricator('card/paragraph') do
  style      { Card::STYLES.sample }
  title      { Faker::Lorem.sentence }
  user
  board      { |attrs| Fabricate(:board, :user => attrs[:user]) }
  topic      { |attrs|
    Fabricate(:topic, :user => attrs[:user], :board => attrs[:board]) }

  content    { Faker::Lorem.paragraph }
end
