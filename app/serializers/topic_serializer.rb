# [Topic] model serializer
class TopicSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :position, :updated_at, :cards

  has_one :user, :embed => :id
  has_one :board, :embed => :id
  has_one :project, :embed => :id
  has_one :aligned_card, :embed => :id
  has_many :comments, :embed => :id
  has_many :activities, :embed => :id

  def cards
    object.cards.map do |card|
      {
        :id => card.id,
        :type => card.type.to_s.demodulize
      }
    end
  end

end
