Fabricator(:whiteboard_membership) do
  creator(:fabricator => :user)
  user
  whiteboard {|attrs| Fabricate(:whiteboard, :user => attrs[:creator])}
end
