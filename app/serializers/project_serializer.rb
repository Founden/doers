class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :updated_at, :logo_url
  attributes :website

  has_one :user, :embed => :ids

  # Get logo URL from attachment
  def logo_url
    object.logo.attachment.url if object.logo
  end
end
