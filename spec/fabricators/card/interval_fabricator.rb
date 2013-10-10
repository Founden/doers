Fabricator('card/interval') do
  style      { Card::STYLES.sample }
  title      { Faker::Lorem.sentence }
  user
  project    { |attrs| Fabricate(:project, :user => attrs[:user]) }
  board      { |attrs| Fabricate(
    :branched_board, :user => attrs[:user], :project => attrs[:project]) }
  topic      { |attrs| Fabricate(
    :topic, :user => attrs[:user], :board => attrs[:board].parent_board) }

  content    { Faker::Lorem.sentence }
  minimum    { rand(0..50).to_f.round(3) }
  maximum    { rand(60..100).to_f.round(3) }
  selected   { |attr|
    rand(Range.new(attr[:minimum], attr[:maximum])).to_f.round(3) }
end
