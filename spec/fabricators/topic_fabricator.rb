Fabricator(:topic) do
  title       { Faker::Lorem.sentence }
  description { Faker::Lorem.phrases(4).join("\n") }
  user
  board       { |attrs| Fabricate(:board, :user => attrs[:user]) }
end

Fabricator(:whiteboard_topic, :from => :topic) do
  user
  whiteboard  { |attrs| Fabricate(:whiteboard, :user => attrs[:user]) }
  board       {}
end
