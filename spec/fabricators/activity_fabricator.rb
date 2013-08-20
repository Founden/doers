Fabricator(:activity) do
  slug      'user:create'
  user
  trackable { |attr| attr['user'] }
end
