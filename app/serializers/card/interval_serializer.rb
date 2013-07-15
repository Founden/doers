# [Card::Interval] model serializer
class Card::IntervalSerializer < CardSerializer
  attributes :minimum, :maximum, :selected
end
