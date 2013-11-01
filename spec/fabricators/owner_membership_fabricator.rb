Fabricator(:owner_membership, :class_name => OwnerMembership) do
  creator(:fabricator => :user)
  user    {|attrs| attrs[:creator] }
  project {|attrs| Fabricate(:project, :user => attrs[:creator])}
end
