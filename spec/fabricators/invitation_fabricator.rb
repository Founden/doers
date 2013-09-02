Fabricator(:invitation) do
  email { sequence(:invitation_email){ Faker::Internet.email } }
  user
end

Fabricator(:project_invitation, :from => :invitation) do
  membership_type Membership::Project.name
  invitable(:fabricator => :project)
end

Fabricator(:board_invitation, :from => :invitation) do
  membership_type Membership::Board.name
  invitable(:fabricator => :board)
end

Fabricator(:project_invitee, :from => :project_invitation) do
  email { Fabricate(:user).email }
  after_create do |inv, trans|
    invitee = User.find_by(:email => inv.email)
    Fabricate('membership/project', :creator => inv.user, :user => invitee)
  end
end

Fabricator(:board_invitee, :from => :board_invitation) do
  email { Fabricate(:user).email }
  after_create do |inv, trans|
    invitee = User.find_by(:email => inv.email)
    Fabricate('membership/board', :creator => inv.user, :user => invitee)
  end
end
