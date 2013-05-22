Fabricator(:angel_list_identity, :class_name => Identities::Oauth2::AngelList) do
  uid       { sequence(:uid_email) { |eid| Faker::Internet.email } }
end
