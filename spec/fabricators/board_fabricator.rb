Fabricator(:board) do
  title    { Faker::Lorem.sentence }
  user
  project
end
