Fabricator(:panel) do
  label    { sequence(:title) { Faker::Lorem.sentence } }
end
