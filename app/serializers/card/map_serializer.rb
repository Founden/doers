# [Card::Map] model serializer
class Card::MapSerializer < CardSerializer
  attributes :latitude, :longitude

  # Manually typecast this until serializer supports it natively
  def latitude
    object.latitude.to_f
  end

  # Manually typecast this until serializer supports it natively
  def longitude
    object.longitude.to_f
  end
end
