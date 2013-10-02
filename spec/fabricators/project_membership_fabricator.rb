Fabricator(:project_membership, :class_name => ProjectMembership) do
  creator(:fabricator => :user)
  user
  project {|attrs| Fabricate(:project, :user => attrs[:creator])}
end
