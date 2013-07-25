Fabricator('card/map') do
  content   { sequence(:addres) { '%s, %s, %s' % [
    Faker::Address.street_address,Faker::Address.city,Faker::Address.country] }}
  title     { sequence(:location) { Faker::Address.neighborhood } }
  latitude  { Faker::Geolocation.lat }
  longitude { Faker::Geolocation.lng }
  user
  board
  project   { nil }
end
