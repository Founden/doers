Fabricator(:user) do
  name                    { sequence(:name) { |nid| Faker::Name.name } }
  email                   { sequence(:email) { |eid| Faker::Internet.email } }
  external_id             { 123 }
  confirmed               { true }
  identities(:count => 1) { |attrs, i|
    Fabricate(:angel_list_identity, :uid => attrs[:email]) }
end

Fabricator(:admin, :from => :user) do
  email                   { 'test@geekcelerator.com' }
end
