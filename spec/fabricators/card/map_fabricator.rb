Fabricator('card/map') do
  location  { sequence(:location) { |lid| 'ClujCowork %s' % lid } }
  address   { '23 Emil Isac str., Cluj-Napoca, Romania' }
  title     { Faker::Lorem.sentence }
  latitude  { Faker::Geolocation.lat }
  longitude { Faker::Geolocation.lng }
  user
  board
  project   { nil }
end
