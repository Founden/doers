# [Board] model serializer
class BoardSerializer < ActiveModel::Serializer
  attributes :id, :title, :status, :updated_at, :description, :card_ids
  attributes :last_update, :author_nicename, :user_nicename
  attributes :branches_count, :cards_count

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

  # If this card has an author, show the author nicename
  def author_nicename
    object.author.nicename if object.author
  end

  # If this card has a user, show the user nicename
  def user_nicename
    object.user.nicename if object.user
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
