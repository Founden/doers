Fabricator(:card) do
  style      { Card::STYLES.sample }
  title      { Faker::Lorem.sentence }
  user
  aligned    { false }
  project    { |attrs| Fabricate(:project, :user => attrs[:user]) }
  board      { |attrs| Fabricate(
    :branched_board, :user => attrs[:user], :project => attrs[:project]) }
  topic      { |attrs| Fabricate(
    :topic, :user => attrs[:user], :board => attrs[:board].parent_board) }
end
