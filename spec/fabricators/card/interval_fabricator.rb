Fabricator('card/interval') do
  title     { Faker::Lorem.sentence }
  minimum   { rand(0..50) }
  maximum   { rand(60..100) }
  selected  { |attr| rand(Range.new(attr[:minimum], attr[:maximum])) }
  user
  board
  project   { nil }
end
