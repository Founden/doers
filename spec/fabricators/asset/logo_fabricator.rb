Fabricator(:logo, :class_name => Asset::Logo) do
  description { sequence(:description) { Faker::Lorem.paragraph } }
  attachment  { File.open(Rails.root.join('spec/fixtures/test.png')) }
end
