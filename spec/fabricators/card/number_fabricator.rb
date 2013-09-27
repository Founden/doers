Fabricator('card/number') do
  style      { Card::STYLES.sample }
  title      { Faker::Lorem.sentence }
  user
  board      { |attrs| Fabricate(:board, :user => attrs[:user]) }
  topic      { |attrs|
    Fabricate(:topic, :user => attrs[:user], :board => attrs[:board]) }

  content    { Faker::Lorem.paragraph }
  number     { rand(1.0..9999.999).to_f.round(3) }
end
