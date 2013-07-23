Fabricator(:board) do
  author(:fabricator => :user)
  title       { Faker::Lorem.sentence }
  description { Faker::Lorem.sentence }
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

Fabricator(:persona_board, :class_name => Board) do
  title       { sequence(:persona_title){|t| 'Persona board nr.%d' % t} }
  description { Faker::Lorem.sentence }
  author(:fabricator => :user)
end

Fabricator(:problem_board, :class_name => Board) do
  title       { sequence(:problem_title){|t| 'Problem board nr.%d' % t} }
  description { Faker::Lorem.sentence }
  author(:fabricator => :user)
end

Fabricator(:solution_board, :class_name => Board) do
  title       { sequence(:solution_title){|t| 'Solution board nr.%d' % t} }
  description { Faker::Lorem.sentence }
  author(:fabricator => :user)
end

Fabricator(:board_with_cards, :from => :branched_board) do
  transient :card_types => %w(book interval link map number paragraph photo phrase timestamp video)
  after_create do |board, transients|
    transients[:card_types].each do |type|
      Fabricate('card/%s' % type, :project => board.project, :board => board, :user => board.user)
    end
  end
end
