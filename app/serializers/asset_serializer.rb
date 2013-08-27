# [Asset] model serializer
class AssetSerializer < ActiveModel::Serializer
  root :asset

  attributes :id, :description, :type, :assetable_type, :assetable_id
  attributes :attachment

  has_one :user, :embed => :id
  has_one :project, :embed => :id
  has_one :board, :embed => :id

  # Serve just asset type
  def type
    object.type.to_s.demodulize
  end
end

