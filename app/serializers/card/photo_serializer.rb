# [Card::Photo] model serializer
class Card::PhotoSerializer < CardSerializer
  attributes :_photo
  has_one :image, :embed => :id

  # Dummy attribute to make happy ember data
  def _photo
  end
end
