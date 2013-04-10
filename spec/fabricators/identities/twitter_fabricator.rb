Fabricator(:password_identity, :class_name => Identities::Oauth::Twitter) do
  uid       { sequence(:email) { |eid| Faker::Internet.email } }
end
