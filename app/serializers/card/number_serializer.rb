# [Card::Number] model serializer
class Card::NumberSerializer < CardSerializer
  root :number
  attributes :content, :number

  # Manually type cast it until serializer supports it natively
  def number
    object.number.to_f
  end
end
