Fabricator(:logo) do
  project
  user
  description { sequence(:description) { Faker::Lorem.paragraph } }
  attachment  { Rack::Test::UploadedFile.new(
      Rails.root.join('spec/fixtures/test.png'), 'image/png') }
end
