Fabricator(:board_membership, :class_name => BoardMembership) do
  creator(:fabricator => :user)
  user
  board {|attrs| Fabricate(:board, :author => attrs[:creator])}
end
