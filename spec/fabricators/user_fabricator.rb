Fabricator(:user) do
  name  { sequence(:name) { |nid| Faker::Name.name } }
  email { sequence(:email) { |eid| Faker::Internet.email } }
end
