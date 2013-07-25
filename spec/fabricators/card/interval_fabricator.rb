Fabricator('card/interval') do
  title     { Faker::Lorem.sentence }
  minimum   { rand(0..50).to_f.round(3) }
  maximum   { rand(60..100).to_f.round(3) }
  selected  { |attr|
    rand(Range.new(attr[:minimum], attr[:maximum])).to_f.round(3) }
  user
  board
  project   { nil }
end
