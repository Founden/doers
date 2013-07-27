require 'spec_helper'

describe Asset do
  context 'attachment is an URI' do
    let(:image_url) { URI.parse('http://test.example.com/test.png') }
    let(:image) { StringIO.new Rails.root.join('spec', 'fixtures', 'test.png').read }

    before do
      OpenURI.should_receive(:open_uri).and_return(image)
    end

    subject { Asset.create(:attachment => image_url) }

    it { should_not be_new_record }
    its(:attachment) { should be_a Paperclip::Attachment }
  end
end
