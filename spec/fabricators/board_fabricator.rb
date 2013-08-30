Fabricator(:board) do
  author(:fabricator => :user)
  title       { Faker::Lorem.sentence }
  description { Faker::Lorem.sentence }
  team
  after_create do |board, trans|
    rand(1..5).times do
      board.tag_names << Faker::Lorem.word
    end
    board.save
    board.cover = Fabricate(
      :cover, :user => (board.author || board.user), :board => board)
  end
end

Fabricator(:branched_board, :class_name => Board) do
  user
  project
  parent_board(:fabricator => :persona_board)
  title       { Faker::Lorem.sentence }
  description { Faker::Lorem.sentence }

  after_create do |board|
    board.parent_board.update_attributes(:status => Board::STATES.last)
  end
end

Fabricator(:public_board, :from => :board) do
  transient   :card_types => %w(card/book card/interval card/link card/map
    card/number card/paragraph card/photo card/phrase card/timestamp card/video)

  status  { Board::STATES.last }

  after_create do |board, transients|
    transients[:card_types].each do |type|
      Fabricate(
        type, :board => board, :user => board.author)
    end
  end
end

Fabricator(:persona_board, :from => :public_board) do
  title       { sequence(:persona_title){|t| 'Persona board nr.%d' % t} }
end

Fabricator(:problem_board, :from => :public_board) do
  title       { sequence(:problem_title){|t| 'Problem board nr.%d' % t} }
end

Fabricator(:solution_board, :from => :public_board) do
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
  end
end
