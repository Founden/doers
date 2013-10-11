# [Card::Video] model serializer
class Card::VideoSerializer < CardSerializer
  root :video
  attributes :video_id, :provider

  has_one :image, :embed => :id
end
