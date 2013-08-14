# [Board] model serializer
class BoardSerializer < ActiveModel::Serializer
  attributes :id, :title, :status, :updated_at, :description, :card_ids
  attributes :branches_count, :cards_count, :last_update

  has_one :user, :embed => :id
  has_one :author, :embed => :id
  has_one :project, :embed => :id
  has_one :parent_board, :embed => :id

  has_many :branches, :embed => :ids
  has_many :cards, :embed => :ids

  # Creates a nice timestamp to indicate when it was last time updated
  def last_update
    object.updated_at.to_s(:pretty)
  end

  # Returns how many times this was branched
  def branches_count
    object.branches.count
  end

  # Returns the number of cards
  def cards_count
    object.cards.count
  end
end
