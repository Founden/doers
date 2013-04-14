Fabricator('field/text_area') do
  content { Faker::HTMLIpsum.fancy_string }
  user
  project
end
