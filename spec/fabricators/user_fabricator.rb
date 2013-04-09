Fabricator(:user) do
  name                    { sequence(:name) { |nid| Faker::Name.name } }
  email                   { sequence(:email) { |eid| Faker::Internet.email } }
  identities(:count => 1) { |attrs, i|
    Fabricate(:password_identity, :uid => attrs[:email]) }
end
