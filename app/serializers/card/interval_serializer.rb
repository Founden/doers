# [Card::Interval] model serializer
class Card::IntervalSerializer < CardSerializer
  attributes :minimum, :maximum, :selected

  # Manually type cast it until serializer supports it natively
  def minimum
    object.minimum.to_f
  end

  # Manually type cast it until serializer supports it natively
  def maximum
    object.maximum.to_f
  end

  # Manually type cast it until serializer supports it natively
  def selected
    object.selected.to_i
  end
end
