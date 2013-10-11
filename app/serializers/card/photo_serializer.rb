# [Card::Photo] model serializer
class Card::PhotoSerializer < CardSerializer
  root :photo
  has_one :image, :embed => :id
end
