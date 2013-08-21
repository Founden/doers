# [Card] model serializer
class CardSerializer < ActiveModel::Serializer
  root :card

  attributes :id, :title, :content, :position, :updated_at, :style
  attributes :type, :question, :help, :title_hint

  has_one :user, :embed => :id
  has_one :project, :embed => :id
  has_one :board, :embed => :id
  has_many :activities, :embed => :id

  # Generates it out of the card type
  def type
    object.type.to_s.demodulize
  end
end
