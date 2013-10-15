Fabricator(:board) do
  user
  title       { Faker::Lorem.sentence }
  description { Faker::Lorem.sentence }
  after_create do |board, trans|
    rand(1..10).times do
      Fabricate(:topic, :board => board, :user => board.user)
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
