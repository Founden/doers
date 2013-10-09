Fabricator(:activity) do
  slug      'user-create'
  user
end

Fabricator(:topic_activity, :from => :activity) do
  board { |attrs| Fabricate(:board, :user => attrs[:user]) }
  topic { |attrs|
    Fabricate(:topic, :user => attrs[:user], :board => attrs[:board]) }
end
