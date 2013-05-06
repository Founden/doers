class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :updated_at

  has_one :user
end
