Fabricator(:activity) do
  slug      'user:create'
  user
  topic   { |attrs| Fabricate(:topic, :user => attrs[:user]) }
end
