# [Card::Photo] model serializer
class Card::PhotoSerializer < CardSerializer
  has_one :image, :embed => :id
end
