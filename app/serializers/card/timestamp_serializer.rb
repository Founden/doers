# [Card::Timestamp] model serializer
class Card::TimestampSerializer < CardSerializer
  attributes :content, :timestamp

  # Localized timestamp
  def timestamp
    DateTime.parse(object.content).to_s(:pretty)
  end
end
