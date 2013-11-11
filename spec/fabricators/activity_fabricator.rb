Fabricator(:activity) do
  slug      'user-create'
  user
end

Fabricator(:topic_activity, :from => :activity) do
  project { |attrs| Fabricate(:project, :user => attrs[:user]) }
  board   { |attrs|
    Fabricate(:board, :user => attrs[:user], :project => attrs[:project]) }
  topic   { |attrs| Fabricate(:topic, :user => attrs[:user],
    :board => attrs[:board], :project => attrs[:project]) }
end
