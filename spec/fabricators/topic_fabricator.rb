Fabricator(:topic) do
  title       { Faker::Lorem.sentence }
  description { Faker::Lorem.sentence }
  user
  project     { |attrs| Fabricate(:project, :user => attrs[:user]) }
  board       { |attrs|
    Fabricate(:board, :user => attrs[:user], :project => attrs[:project]) }
end
