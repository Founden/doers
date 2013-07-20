Fabricator(:image) do
  description { sequence(:description) { Faker::Lorem.paragraph } }
  attachment  { File.open(Rails.root.join('spec/fixtures/test.png')) }
end

Fabricator(:image_to_upload, :from => :image) do
  user
  project
  board
  assetable_type { nil }
  assetable_id   { nil }
  type           { Image }
  attachment     { Rack::Test::UploadedFile.new(
    Rails.root.join('spec/fixtures/test.png'), 'image/png') }
end
