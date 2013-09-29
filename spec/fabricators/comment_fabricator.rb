Fabricator(:comment) do
  content { Faker::HTMLIpsum.fancy_string }
  user
  project { |attrs| Fabricate(:project, :user => attrs[:user]) }
end

Fabricator(:comment_with_parent, :from => :comment) do
  parent_comment { |attrs| Fabricate(:comment, :project => attrs[:project]) }
end

Fabricator(:board_comment, :from => :comment) do
  content     { Faker::HTMLIpsum.fancy_string }
  project     { |attrs| Fabricate(:project, :user => attrs[:user]) }
  board       { |attrs| Fabricate(
    :branched_board, :project => attrs[:project], :author => attrs[:user]) }
  topic       {}
end

Fabricator(:topic_comment, :from => :board_comment) do
  topic   { |attrs| Fabricate(:topic, :user => attrs[:user],
    :project => attrs[:project], :board => attrs[:board]) }
end

Fabricator(:topic_comment_with_parent, :from => :topic_comment) do
  parent_comment { |attrs|
    Fabricate(:comment, :project => attrs[:project], :board => attrs[:board]) }
end

Fabricator(
  :topic_comment_with_parent_and_card, :from => :topic_comment_with_parent) do
  card { |attrs| Fabricate('card/phrase', :project => attrs[:project],
    :board => attrs[:board], :topic => attrs[:topic]) }
end

Fabricator(:comment_from_angel_list, :class_name => Comment) do
  project
  content                 { Faker::HTMLIpsum.fancy_string }
  external_id             { sequence(:external_id, 1000) }
  external_type           { Doers::Config.external_types.first }
  external_author_name    { Faker::Name.name }
  external_author_id      { sequence(:external_id) }
end
