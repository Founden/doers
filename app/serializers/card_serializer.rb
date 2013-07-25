# [Card] model serializer
class CardSerializer < ActiveModel::Serializer
  root :card

  attributes :id, :title, :position, :updated_at
  attributes :last_update, :user_nicename, :type

  has_one :user, :embed => :id
  has_one :project, :embed => :id
  has_one :board, :embed => :id

  # Creates a nice timestamp to indicate when it was last time updated
  def last_update
    object.updated_at.to_s(:pretty)
  end

  # If this card has a user, show the user nicename
  def user_nicename
    object.user.nicename if object.user
  end

  # Generates it out of the card type
  def type
    object.type.to_s.demodulize
  end
end
