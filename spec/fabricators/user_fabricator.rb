Fabricator(:user) do
  name                    { sequence(:name) { |nid| Faker::Name.name } }
  email                   { sequence(:email) { |eid| Faker::Internet.email } }
  external_id             { sequence(:external_id) }
  confirmed               { true }
  identities(:count => 1) { |attrs, i|
    Fabricate(:angel_list_identity, :uid => attrs[:email]) }
end

Fabricator(:user_with_projects, :from => :user) do
  transient :projects_count => 3

  after_create do |user, transients|
    transients[:projects_count].times do
      Fabricate(:project, :user => user)
    end
  end
end

Fabricator(:admin, :from => :user) do
  email                   { 'test@geekcelerator.com' }
end
