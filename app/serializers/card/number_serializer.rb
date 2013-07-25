# [Card::Number] model serializer
class Card::NumberSerializer < CardSerializer
  attributes :content

  # Manually type cast it until serializer supports it natively
  def content
    object.content.to_f
  end
end
