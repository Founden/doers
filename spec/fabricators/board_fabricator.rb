Fabricator(:board) do
  author(:fabricator => :user)
  title       { Faker::Lorem.sentence }
  description { Faker::Lorem.sentence }
  team        { Fabricate(:team, :boards_count => 0) }
  after_create do |board, trans|
    rand(1..5).times do
      board.tag_names << Faker::Lorem.word
    end
    board.save
    board.cover = Fabricate(:cover, :user => board.author, :board => board)
    rand(1..10).times do
      Fabricate(:topic, :board => board, :user => board.author)
    end
  end
end

Fabricator(:branched_board, :class_name => Board) do
  user
  project
  parent_board(:fabricator => :public_board)
  title       { Faker::Lorem.sentence }
  description { Faker::Lorem.sentence }

  after_create do |board|
    board.cover = Fabricate(:cover, :user => board.user, :board => board)
  end
end

Fabricator(:public_board, :from => :board) do
  transient   :card_types => %w(card/book card/interval card/link card/map
    card/number card/paragraph card/photo card/phrase card/timestamp card/video)

  status  { Board::STATES.last }

  after_create do |board, transients|
    transients[:card_types].each do |type|
      Fabricate(type, :board => board, :user => board.author)
    end
  end
end

Fabricator(:public_board_with_invitations, :from => :public_board) do
  after_create do |board, transients|
    [0, 1, 2].sample.times do
      Fabricate(:board_invitation, :user => board.author, :invitable => board)
    end
    [0, 1, 2].sample.times do
      Fabricate(:board_invitee, :user => board.author, :invitable => board)
    end
  end
end

Fabricator(:persona_board, :from => :public_board_with_invitations) do
  title       { sequence(:persona_title){|t| 'Persona board nr.%d' % t} }
end

Fabricator(:problem_board, :from => :public_board_with_invitations) do
  title       { sequence(:problem_title){|t| 'Problem board nr.%d' % t} }
end

Fabricator(:solution_board, :from => :public_board_with_invitations) do
  title       { sequence(:solution_title){|t| 'Solution board nr.%d' % t} }
end

Fabricator(:board_with_cards, :from => :branched_board) do
  transient   :card_types => %w(card/book card/interval card/link card/map
    card/number card/paragraph card/photo card/phrase card/timestamp card/video)

  after_create do |board, transients|
    transients[:card_types].each do |type|
      Fabricate(
        type, :project => board.project, :board => board, :user => board.user)
    end

    [0, 1, 2].sample.times do
      Fabricate(:board_invitation, :user => board.user, :invitable => board)
    end
    [0, 1, 2].sample.times do
      Fabricate(:board_invitee, :user => board.user, :invitable => board)
    end
  end
end
