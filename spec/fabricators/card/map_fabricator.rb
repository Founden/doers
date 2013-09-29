Fabricator('card/map') do
  style      { Card::STYLES.sample }
  title      { Faker::Lorem.sentence }
  user
  project    { |attrs| Fabricate(:project, :user => attrs[:user]) }
  board      { |attrs| Fabricate(
    :branched_board, :user => attrs[:user], :project => attrs[:project]) }
  topic      { |attrs|
    Fabricate(:topic, :user => attrs[:user], :board => attrs[:board]) }

  latitude   { Faker::Geolocation.lat.round(10) }
  longitude  { Faker::Geolocation.lng.round(10) }
  content    { sequence(:addres) { '%s, %s, %s' % [
    Faker::Address.street_address,Faker::Address.city,Faker::Address.country] }}
end
