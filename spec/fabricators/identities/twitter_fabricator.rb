Fabricator(:twitter_identity, :class_name => Identities::Oauth::Twitter) do
  uid       { sequence(:uid_email) { |eid| Faker::Internet.email } }
end
