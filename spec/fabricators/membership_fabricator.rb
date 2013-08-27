Fabricator('membership/project') do
  creator(:fabricator => :user)
  user
  project
end

Fabricator('membership/board') do
  creator(:fabricator => :user)
  user
  board
end
