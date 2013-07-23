# [Card::Video] model serializer
class Card::VideoSerializer < CardSerializer
  attributes :video_id, :provider

  has_one :image, :embed => :id
end
