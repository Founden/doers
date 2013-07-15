Fabricator('card/video') do
  title     { Faker::Lorem.sentence }
  video_id  { %w(1D1cap6yETA sTSA_sWGM44 QH2-TGUlwu4).sample }
  provider  { Card::Video::PROVIDERS.sample }
  user
  board
  project   { nil }
  after_create do |video_card, trans|
    video_card.image = Fabricate.build(:image, :user => video_card.user,
      :board => video_card.board, :assetable => video_card)
  end
end
