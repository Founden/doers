Fabricator('card/book') do
  style      { Card::STYLES.sample }
  title      { Faker::Lorem.sentence }
  user
  project    { |attrs| Fabricate(:project, :user => attrs[:user]) }
  board      { |attrs| Fabricate(
    :branched_board, :user => attrs[:user], :project => attrs[:project]) }
  topic      { |attrs| Fabricate(
    :topic, :user => attrs[:user], :board => attrs[:board].parent_board) }

  book_title   { Faker::Lorem.sentence }
  url          { Faker::Internet.http_url }
  book_authors { rand(1..3).times.collect { Faker::Name.name }.join(', ') }

  after_create do |book_card, trans|
    book_card.image = Fabricate(
      :image, :user => book_card.user, :board => book_card.board,
      :assetable => book_card, :project => book_card.project)
  end
end
