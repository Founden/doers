Fabricator('field/options') do
  title { Faker::Lorem.phrase }
  options {
    opts = [
      {:label => Faker::Lorem.sentence, :selected => [true, false].sample},
      {:label => Faker::Lorem.sentence, :selected => [true, false].sample},
      {:label => Faker::Lorem.sentence, :selected => [true, false].sample}
    ]
    opts.map(&:with_indifferent_access)
  }
  user
  project
end
