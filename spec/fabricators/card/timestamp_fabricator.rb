Fabricator('card/timestamp') do
  style      { Card::STYLES.sample }
  title      { Faker::Lorem.sentence }
  user
  board      { |attrs| Fabricate(:board, :user => attrs[:user]) }
  topic      { |attrs|
    Fabricate(:topic, :user => attrs[:user], :board => attrs[:board]) }

  content    { DateTime.now.to_s }
end
