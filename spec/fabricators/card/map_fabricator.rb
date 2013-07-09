Fabricator('card/map') do
  location  { Faker::Lorem.sentence }
  address   { '23 Emil Isac str., Cluj-Napoca, Romania' }
  title     { Faker::Lorem.sentence }
  user
  board
  project   { nil }
end
