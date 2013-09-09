Fabricator('card/photo') do
  transient  :public_board
  title      { |attrs| Faker::Lorem.sentence unless attrs[:public_board] }
  title_hint { Faker::Lorem.sentence }
  user
  board
  project    { nil }
  question   { Faker::Lorem.sentence }
  help       { Faker::Lorem.phrases(4).join("\n") }
  after_create do |photo_card, trans|
    photo_card.image = Fabricate.build(
      :image, :user => photo_card.user, :board => photo_card.board,
      :assetable => photo_card, :project => photo_card.project)
  end
end
