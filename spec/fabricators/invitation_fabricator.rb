Fabricator(:invitation) do
  email { sequence(:invitation_email){ Faker::Internet.email } }
  user
end

Fabricator(:project_invitation, :from => :invitation) do
  membership_type ProjectMembership.name
  invitable { |attrs| Fabricate(:project, :user => attrs[:user]) }
end

Fabricator(:board_invitation, :from => :invitation) do
  membership_type BoardMembership.name
  invitable { |attrs|
    prj = Fabricate(:project, :user => attrs[:user])
    Fabricate(:branched_board, :user => attrs[:user], :project => prj)
  }
end

Fabricator(:public_board_invitation, :from => :invitation) do
  membership_type BoardMembership.name
  invitable { |attrs| Fabricate(:public_board, :author => attrs[:user]) }
end

Fabricator(:project_invitee, :from => :project_invitation) do
  email { Fabricate(:user).email }
  after_create do |inv, trans|
    invitee = User.find_by(:email => inv.email)
    inv.membership_id = Fabricate(:project_membership,
      :creator => inv.user, :user => invitee, :project => inv.invitable).id
    inv.save
  end
end

Fabricator(:board_invitee, :from => :board_invitation) do
  email { Fabricate(:user).email }
  after_create do |inv, trans|
    invitee = User.find_by(:email => inv.email)
    inv.membership_id = Fabricate(:board_membership,
      :creator => inv.user, :user => invitee, :board => inv.invitable).id
    inv.save
  end
end
