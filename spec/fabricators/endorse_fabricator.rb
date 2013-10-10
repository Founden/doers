Fabricator(:endorse) do
  user
  project { |attrs| Fabricate(:project, :user => attrs[:user]) }
  board   { |attrs| Fabricate(
    :branched_board, :user => attrs[:user], :project => attrs[:project]) }
  topic    { |attrs| attrs[:board].parent_board.topics.first }
  card    { |attrs| Fabricate('card/phrase', :topic => attrs[:topic],
    :project => attrs[:project], :board => attrs[:board],:user => attrs[:user])}
end
