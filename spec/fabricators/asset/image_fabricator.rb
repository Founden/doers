Fabricator(:image, :class_name => Asset::Image) do
  description { sequence(:description) { Faker::Lorem.paragraph } }
  attachment  { File.open(Rails.root.join('spec/fixtures/test.png')) }
end

Fabricator(:image_to_upload, :from => :image) do
  user
  project
  board
  assetable_type { nil }
  assetable_id   { nil }
  type           { %w(Image Logo Cover).sample }
  attachment     { Rack::Test::UploadedFile.new(
    Rails.root.join('spec/fixtures/test.png'), 'image/png') }
end
