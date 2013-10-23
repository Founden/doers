Fabricator('card/paragraph') do
  style      { Card::STYLES.sample }
  title      { Faker::Lorem.sentence }
  user
  project    { |attrs| Fabricate(:project, :user => attrs[:user]) }
  board      { |attrs| Fabricate(
    :board, :user => attrs[:user], :project => attrs[:project]) }
  topic      { |attrs| Fabricate(
    :topic, :user => attrs[:user], :board => attrs[:board]) }

  content    { Faker::Lorem.paragraph }
end
