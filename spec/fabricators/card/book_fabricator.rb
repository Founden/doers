Fabricator('card/book') do
  title        { Faker::Lorem.sentence }
  title_hint   { Faker::Lorem.sentence }
  user
  board
  book_title   { Faker::Lorem.sentence }
  url          { Faker::Internet.http_url }
  project      { nil }
  question     { Faker::Lorem.sentence }
  help         { Faker::Lorem.phrases(4).join("\n") }
  book_authors {
    rand(1..3).times.collect { Faker::Name.name }.join(', ') }

  after_create do |book_card, trans|
    book_card.image = Fabricate.build(
      :image, :user => book_card.user, :board => book_card.board,
      :assetable => book_card, :project => book_card.project)
  end
end
