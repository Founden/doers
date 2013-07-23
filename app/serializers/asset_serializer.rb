# [Asset] model serializer
class AssetSerializer < ActiveModel::Serializer
  root :asset

  attributes :id, :description, :type, :assetable_type, :assetable_id
  attributes :attachment
  attributes :user_nicename

  has_one :user, :embed => :id
  has_one :project, :embed => :id
  has_one :board, :embed => :id

  # If this card has a user, show the user nicename
  def user_nicename
    object.user.nicename if object.user
  end
end

