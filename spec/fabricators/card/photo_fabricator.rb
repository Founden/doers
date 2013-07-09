Fabricator('card/photo') do
  title   { Faker::Lorem.sentence }
  user
  board
  project { nil }
  after_create do |photo_card, trans|
    photo_card.image = Fabricate.build(:image, :user => photo_card.user,
      :board => photo_card.board, :assetable => photo_card)
  end
end
