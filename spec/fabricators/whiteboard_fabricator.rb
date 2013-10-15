Fabricator(:whiteboard) do
  user
  title       { Faker::Lorem.sentence }
  description { Faker::Lorem.sentence }
  team        { Fabricate(:team, :boards_count => 0) }
  after_create do |board, trans|
    rand(1..5).times do
      board.tag_names << Faker::Lorem.word
    end
    board.save
    # board.cover = Fabricate(:cover, :user => board.user, :board => board)
  end
end
