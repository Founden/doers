Fabricator(:password_identity, :class_name => Identities::Password) do
  uid       { sequence(:email) { |eid| Faker::Internet.email } }
  password  'secret'
end
