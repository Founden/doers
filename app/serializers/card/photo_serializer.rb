# [Card::Photo] model serializer
class Card::PhotoSerializer < CardSerializer
  root :photo
  attributes :image

  def image
    {
      :id => object.image.id,
      :type => object.image.type.to_s.demodulize
    } if object.image
  end
end
