Fabricator(:project) do
  title       { sequence(:title) { Faker::Lorem.sentence } }
  description { sequence(:description) { Faker::Lorem.paragraph } }
end
