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
  transient :boards_count => 3

  after_create  { |project, transients|
    transients[:boards_count].times do
      Fabricate(:branched_board, :project => project, :user => project.user)
    end
  }
end

Fabricator(:project_with_boards_and_cards, :from => :project) do
  transient :boards_count => 1
  transient :card_types

  after_create do |project, transients|
    transients[:boards_count].times {
      if card_types = transients[:card_types]
        Fabricate(:board_with_cards,
          :user => project.user, :project => project, :card_types => card_types)
      else
        Fabricate(:board_with_cards, :user => project.user, :project => project)
      end
    }
  end
end
