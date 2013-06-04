Fabricator(:project) do
  title       { sequence(:title) { Faker::Lorem.sentence } }
  description { sequence(:description) { Faker::Lorem.paragraph } }
  website     { sequence(:www) { Faker::Internet.uri(:https) } }
  user
end
