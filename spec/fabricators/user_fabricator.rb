Fabricator(:user) do
  name                    { sequence(:name) { |nid| Faker::Name.name } }
  email                   { sequence(:email) { |eid| Faker::Internet.email } }
  angel_list_id           { 123 }
  identities(:count => 1) { |attrs, i|
    Fabricate(:angel_list_identity, :uid => attrs[:email]) }
end
