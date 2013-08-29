require 'spec_helper'

describe Asset::Cover do
  include Paperclip::Shoulda::Matchers

  it { should have_attached_file(:attachment) }
  it { should validate_attachment_content_type(:attachment)
              .allowing(Asset::IMAGE_TYPES)
              .rejecting('text/plain')
  }
  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should belong_to(:board) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:board) }

  context 'sanitization' do
    let(:bad_input) do
      Faker::HTMLIpsum.body + '
      <script>alert("PWND")</script>
      <iframe src="http://pwnr.com/pwnd"></iframe>'
    end

    subject { Fabricate.build(:cover, :description => bad_input) }

    its(:description){ should_not match(/\<\>/) }
  end
end
