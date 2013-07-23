Fabricator(:project) do
  transient   :boards_count => 1
  title       { sequence(:title) { Faker::Company.name } }
  description { sequence(:description) { Faker::Lorem.paragraph } }
  website     { sequence(:www) { Faker::Internet.uri(:https) } }
  user
  after_create do |project|
    Fabricate(:logo, :project => project, :user => project.user)
  end
end

Fabricator(:project_with_boards, :from => :project) do
  after_create do |project, transients|
    transients[:boards_count].times { Fabricate(:board_with_cards, :user => project.user, :project => project) }
  end
end
