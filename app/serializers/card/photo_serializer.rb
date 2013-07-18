# [Card::Photo] model serializer
class Card::PhotoSerializer < CardSerializer
  attributes :image_url

  has_one :image, :embed => :id, :key => :asset_id

  # Get image url from attachment
  def image_url
    object.image.attachment.url if object.image
  end
end
