# [Card::Map] model serializer
class Card::MapSerializer < CardSerializer
  attributes :location, :address, :latitude, :longitude
end
