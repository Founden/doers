Fabricator(:project) do
  title       { sequence(:title) { Faker::Company.name } }
  description { sequence(:description) { Faker::Lorem.paragraph } }
  website     { sequence(:www) { Faker::Internet.uri(:https) } }
  user
  after_create do |project|
    Fabricate(:logo, :project => project, :user => project.user)
  end
end

Fabricator(:project_with_boards, :from => :project) do
  boards(:count => 5)
end
