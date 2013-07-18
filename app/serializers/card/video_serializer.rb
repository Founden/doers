# [Card::Video] model serializer
class Card::VideoSerializer < CardSerializer
  attributes :video_id, :provider
  attributes :image_url

  has_one :image, :embed => :id, :key => :asset_id

  # Get image url from attachment
  def image_url
    object.image.attachment.url if object
  end
end
