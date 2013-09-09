Fabricator('card/interval') do
  transient  :public_board
  title      { |attrs| Faker::Lorem.sentence unless attrs[:public_board] }
  title_hint { Faker::Lorem.sentence }
  content    { Faker::Lorem.sentence }
  minimum    { rand(0..50).to_f.round(3) }
  maximum    { rand(60..100).to_f.round(3) }
  user
  board
  project    { nil }
  question   { Faker::Lorem.sentence }
  help       { Faker::Lorem.phrases(4).join("\n") }
  selected   { |attr|
    rand(Range.new(attr[:minimum], attr[:maximum])).to_f.round(3) }
end
