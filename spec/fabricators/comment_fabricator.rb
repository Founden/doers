Fabricator(:comment) do
  project
  board
  user
  content { Faker::HTMLIpsum.fancy_string }
end

Fabricator(:comment_with_parent, :from => :comment) do
  parent_comment(:fabricator => :comment)
end
