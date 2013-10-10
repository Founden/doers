Fabricator('card/photo') do
  style      { Card::STYLES.sample }
  title      { Faker::Lorem.sentence }
  user
  project    { |attrs| Fabricate(:project, :user => attrs[:user]) }
  board      { |attrs| Fabricate(
    :branched_board, :user => attrs[:user], :project => attrs[:project]) }
  topic      { |attrs| Fabricate(
    :topic, :user => attrs[:user], :board => attrs[:board].parent_board) }

  content    { Faker::Lorem.paragraph }

  after_create do |photo_card, trans|
    photo_card.image = Fabricate.build(
      :image, :user => photo_card.user, :board => photo_card.board,
      :assetable => photo_card, :project => photo_card.project)
  end
end
