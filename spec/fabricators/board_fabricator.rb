Fabricator(:board) do
  transient   :topics_count => 4
  user
  project
  title       { Faker::Lorem.sentence }
  description { Faker::Lorem.sentence }
  after_create do |board, trans|
    trans[:topics_count].times do
      Fabricate(
        :topic, :board => board, :user => board.user, :project => board.project)
    end
  end
end

Fabricator(:board_with_invitations, :from => :board) do
  after_create do |board, transients|
    [0, 1, 2].sample.times do
      Fabricate(:board_invitation, :user => board.user, :invitable => board)
    end
    [0, 1, 2].sample.times do
      Fabricate(:board_invitee, :user => board.user, :invitable => board)
    end
  end
end
