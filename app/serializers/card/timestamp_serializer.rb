# [Card::Timestamp] model serializer
class Card::TimestampSerializer < CardSerializer
  attributes :timestamp, :parsed_timestamp

  # Localized timestamp
  def parsed_timestamp
    DateTime.parse(object.timestamp).to_s(:pretty)
  end
end
