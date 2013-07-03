Fabricator('card/book') do
  title { Faker::Lorem.sentence }
  user
  board
  book_title { Faker::Lorem.sentence }
  book_authors { rand(1..3).times.collect{ Faker::Name.name }.join(', ') }
  url { Faker::Internet.http_url }
  after_create do |book_card, trans|
    book_card.image = Fabricate.build(:image, :user => book_card.user,
      :board => book_card.board, :assetable => book_card)
  end
end
