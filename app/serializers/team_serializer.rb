# [Team] model serializer
class TeamSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :slug, :website, :angel_list

  has_many :users, :embed => :id
  has_many :whiteboards, :embed => :id
  has_one :banner, :embed => :id
end

