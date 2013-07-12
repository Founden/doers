Fabricator('card/interval') do
  title     { Faker::Lorem.sentence }
  minimum   { rand(0..50).to_f }
  maximum   { rand(60..100).to_f }
  selected  { |attr| rand(Range.new(attr[:minimum], attr[:maximum])).to_f }
  user
  board
  project   { nil }
end
