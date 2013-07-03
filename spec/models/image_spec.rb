require 'spec_helper'

describe Image do
  include Paperclip::Shoulda::Matchers

  it { should have_attached_file(:attachment) }
  it { should validate_attachment_content_type(:attachment)
              .allowing(Image::IMAGE_TYPES)
              .rejecting('text/plain')
  }
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should belong_to(:board) }
  it { should belong_to(:assetable) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:board) }
  it { should validate_presence_of(:assetable) }

  context 'sanitization' do
    let(:bad_input) do
      Faker::HTMLIpsum.body + '
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>'
    end

    subject { Fabricate.build(:image, :description => bad_input) }

    its(:description){ should_not match(/\<\>/) }
  end

  context 'attachment must be downloaded' do
    let(:image_url) { URI.parse('http://test.example.com/test.png') }
    let(:image) { Fabricate.build(:image, :attachment => image_url) }

    subject { image }

    before do
      stub_request(:get, image_url.to_s).to_return(
        :body => File.read(Rails.root.join('spec/fixtures/test.png')),
        :headers => { 'Content-Type' => 'image/png' }
      )
      image.save
    end

    its(:attachment) { should_not be_nil }
  end

end
