# [Asset] model serializer
class AssetSerializer < ActiveModel::Serializer
  root :asset

  attributes :id, :description, :type, :assetable_type, :assetable_id
  attributes :attachment, :thumb_size_url, :small_size_url, :medium_size_url

  has_one :user, :embed => :id
  has_one :project, :embed => :id
  has_one :board, :embed => :id
  has_one :whiteboard, :embed => :id

  # Thumb size of the attachment
  def thumb_size_url
    object.attachment.url(:thumb)
  end

  # Small size of the attachment
  def small_size_url
    object.attachment.url(:small)
  end

  # Medium size of the attachment
  def medium_size_url
    object.attachment.url(:medium)
  end

  # Serve just asset type
  def type
    object.type.to_s.demodulize
  end
end

