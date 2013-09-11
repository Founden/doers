Fabricator('card/list') do
  transient  :public_board
  title      { |attrs| Faker::Lorem.sentence unless attrs[:public_board] }
  content    { Faker::Lorem.sentence }
  title_hint { Faker::Lorem.sentence }
  user
  board
  project    { nil }
  question   { Faker::Lorem.sentence }
  help       { Faker::Lorem.phrases(4).join("\n") }
  items      { rand(2..5).times.collect do
    {'label' => Faker::Lorem.sentence, 'checked' => [true, false].sample}
  end }
end
