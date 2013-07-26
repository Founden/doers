Fabricator('card/map') do
  content   { sequence(:addres) { '%s, %s, %s' % [
    Faker::Address.street_address,Faker::Address.city,Faker::Address.country] }}
  title     { sequence(:location) { Faker::Address.neighborhood } }
  latitude  { Faker::Geolocation.lat.round(10) }
  longitude { Faker::Geolocation.lng.round(10) }
  user
  board
  project   { nil }
end
