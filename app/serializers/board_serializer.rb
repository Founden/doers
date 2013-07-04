# [Board] model serializer
class BoardSerializer < ActiveModel::Serializer
  attributes :id, :title, :status, :updated_at, :description

  has_one :user, :embed => :ids
  has_one :author, :embed => :ids
  has_one :project, :embed => :ids
  has_one :parent_board, :embed => :ids

  has_many :branches, :embed => :ids
  has_many :cards, :embed => :ids
end
