# [Card::Map] model serializer
class Card::MapSerializer < CardSerializer
  attributes :latitude, :longitude, :_map

  # Manually typecast this until serializer supports it natively
  def latitude
    object.latitude.to_f
  end

  # Manually typecast this until serializer supports it natively
  def longitude
    object.longitude.to_f
  end

  # Dummy attribute to make happy ember data
  def _map
  end
end
