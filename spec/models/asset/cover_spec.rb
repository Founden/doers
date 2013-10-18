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
  it { should belong_to(:whiteboard) }

  it { should validate_presence_of(:user) }

  context 'validations' do
    let(:board) { Fabricate(:whiteboard) }
    let(:whiteboard) { Fabricate(:whiteboard) }
    let(:cover) { Fabricate.build(:cover) }

    subject { cover }

    it { should_not be_valid }

    context 'board is not set' do
      let(:cover) { Fabricate.build(
          :cover, :whiteboard => whiteboard, :user => whiteboard.user) }

      it { should be_valid }
    end

    context 'whiteboard is not set' do
      let(:cover) {
        Fabricate.build(:cover, :whiteboard => board, :user => board.user) }

      it { should be_valid }
    end
  end

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
