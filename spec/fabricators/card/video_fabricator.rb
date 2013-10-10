Fabricator('card/video') do
  style      { Card::STYLES.sample }
  title      { Faker::Lorem.sentence }
  user
  project    { |attrs| Fabricate(:project, :user => attrs[:user]) }
  board      { |attrs| Fabricate(
    :branched_board, :user => attrs[:user], :project => attrs[:project]) }
  topic      { |attrs| Fabricate(
    :topic, :user => attrs[:user], :board => attrs[:board].parent_board) }

  video_id   { %w(1D1cap6yETA sTSA_sWGM44 QH2-TGUlwu4).sample }
  provider   { Card::Video::PROVIDERS.sample }

  after_create do |video_card, trans|
    video_card.image = Fabricate.build(
      :image, :user => video_card.user, :board => video_card.board,
      :assetable => video_card, :project => video_card.project)
  end
end
