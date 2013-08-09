# [Card] model serializer
class CardSerializer < ActiveModel::Serializer
  root :card

  attributes :id, :title, :content, :position, :updated_at, :style
  attributes :user_nicename, :type, :question, :help, :title_hint

  has_one :user, :embed => :id
  has_one :project, :embed => :id
  has_one :board, :embed => :id

  # If this card has a user, show the user nicename
  def user_nicename
    object.user.nicename if object.user
  end

  # Generates it out of the card type
  def type
    object.type.to_s.demodulize
  end
end
