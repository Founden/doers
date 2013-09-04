Fabricator(:project_membership, :class_name => ProjectMembership) do
  creator(:fabricator => :user)
  user
  project
end
