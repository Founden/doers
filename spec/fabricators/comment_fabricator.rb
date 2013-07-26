Fabricator(:comment) do
  project
  board
  user
  content { Faker::HTMLIpsum.fancy_string }
end

Fabricator(:comment_with_parent, :from => :comment) do
  parent_comment { |attrs| Fabricate(:comment, :project => attrs[:project]) }
end

Fabricator(:comment_from_angel_list, :class_name => Comment) do
  project
  content                 { Faker::HTMLIpsum.fancy_string }
  external_id             { sequence(:external_id, 1000) }
  external_type           { Doers::Config.external_types.first }
  external_author_name    { Faker::Name.name }
  external_author_id      { sequence(:external_id) }
end
