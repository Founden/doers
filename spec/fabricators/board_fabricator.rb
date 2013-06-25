Fabricator(:board) do
  author(:fabricator => :user)
  title { Faker::Lorem.sentence }
end
