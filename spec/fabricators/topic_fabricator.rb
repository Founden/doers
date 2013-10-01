Fabricator(:topic) do
  title       { Faker::Lorem.sentence }
  description { Faker::Lorem.phrases(4).join("\n") }
  user
  board       { |attrs| Fabricate(:board, :author => attrs[:user]) }
end