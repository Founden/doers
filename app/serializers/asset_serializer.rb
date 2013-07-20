# [Asset] model serializer
class AssetSerializer < ActiveModel::Serializer
  root :asset

  attributes :id, :description, :type, :assetable_type, :assetable_id
  attributes :attachment_url, :user_nicename

  has_one :user, :embed => :id
  has_one :project, :embed => :id
  has_one :board, :embed => :id

  # If this card has a user, show the user nicename
  def user_nicename
    object.user.nicename if object.user
  end

  # Attachment URL helper
  def attachment_url
    object.attachment.url if object.attachment
  end
end

