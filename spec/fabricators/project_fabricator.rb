Fabricator(:project) do
  title         { sequence(:title)       { Faker::Company.name.delete("'") } }
  description   { sequence(:description) { Faker::Company.catch_phrase } }
  website       { sequence(:www)         { Faker::Internet.uri(:https) } }
  user
  after_create do |project|
    Fabricate(:logo, :project => project, :user => project.user)
  end
end

Fabricator(:project_with_invitations, :from => :project) do
  after_create do |project|
    [0, 1, 2].sample.times do
      Fabricate(:project_invitation,:user => project.user,:invitable => project)
    end
    [0, 1, 2].sample.times do
      Fabricate(:project_invitee, :user => project.user, :invitable => project)
    end
  end
end

Fabricator(:project_with_memberships, :from => :project) do
  transient :memberships_count => 3

  after_create do |project, transients|
    transients[:memberships_count].times do
      Fabricate(:project_membership, :project => project, :creator => project.user)
    end
  end
end

Fabricator(:imported_project, :from => :project) do
  external_id   { sequence(:external_id, 2000) }
  external_type { Doers::Config.external_types.first }
end

Fabricator(:project_with_boards, :from => :project) do
  transient :boards_count => 3

  after_create  { |project, transients|
    transients[:boards_count].times do
      Fabricate(:board, :project => project, :user => project.user)
    end
  }
end
