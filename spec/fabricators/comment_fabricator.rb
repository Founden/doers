Fabricator(:comment) do
  content     { Faker::HTMLIpsum.fancy_string }
  user
  project     { |attrs| Fabricate(:project, :user => attrs[:user]) }
  board       { |attrs| Fabricate(
    :board, :project => attrs[:project], :author => attrs[:user]) }
end

Fabricator(:comment_with_parent, :from => :comment) do
  parent_comment { |attrs| Fabricate(:comment, :project => attrs[:project]) }
end

Fabricator(:board_comment, :from => :comment) do
  content     { Faker::HTMLIpsum.fancy_string }
  project     { |attrs| Fabricate(:project, :user => attrs[:user]) }
  board       { |attrs| Fabricate(
    :board, :project => attrs[:project], :author => attrs[:user]) }
end

Fabricator(:card_comment, :from => :board_comment) do
  commentable { |attrs|
    Fabricate('card/phrase', :project => attrs[:project],
              :board => attrs[:board], :user => attrs[:user]) }
end

Fabricator(:card_comment_with_parent, :from => :board_comment) do
  parent_comment { |attrs|
    Fabricate(:comment, :project => attrs[:project], :board => attrs[:board]) }
  commentable { |attrs|
    Fabricate('card/phrase', :project => attrs[:project],
              :board => attrs[:board], :user => attrs[:user]) }
end

Fabricator(:comment_from_angel_list, :class_name => Comment) do
  project
  content                 { Faker::HTMLIpsum.fancy_string }
  external_id             { sequence(:external_id, 1000) }
  external_type           { Doers::Config.external_types.first }
  external_author_name    { Faker::Name.name }
  external_author_id      { sequence(:external_id) }
end
