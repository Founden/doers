Fabricator(:logo) do
  project
  user
  description { sequence(:description) { Faker::Lorem.paragraph } }
  attachment  { File.open(Rails.root.join('spec/fixtures/test.png')).close }
end
