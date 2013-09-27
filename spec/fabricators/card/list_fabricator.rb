Fabricator('card/list') do
  style      { Card::STYLES.sample }
  title      { Faker::Lorem.sentence }
  user
  board      { |attrs| Fabricate(:board, :user => attrs[:user]) }
  topic      { |attrs|
    Fabricate(:topic, :user => attrs[:user], :board => attrs[:board]) }

  content    { Faker::Lorem.paragraph }
  items      { rand(2..5).times.collect do
    {'label' => Faker::Lorem.sentence, 'checked' => [true, false].sample}
  end }
end
