Fabricator(:comment) do
  project
  board
  user
  content { Faker::HTMLIpsum.fancy_string }
end

Fabricator(:comment_with_parent, :from => :comment) do
  parent_comment(:fabricator => :comment)
end

Fabricator(:comment_from_angel_list, :class_name => Comment) do
  project
  content                 { Faker::HTMLIpsum.fancy_string }
  angel_list_id           { 1234 }
  angel_list_author_name  { Faker::Name.name }
  angel_list_author_id    { 123 }
end
