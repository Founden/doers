require 'spec_helper'

describe Card::Book do
  it { should have_one(:image).dependent(:destroy) }
  it { should belong_to(:parent_card) }
  it { should have_many(:versions).dependent(:destroy) }
  it { should validate_presence_of(:book_title) }
  it { should validate_presence_of(:book_authors) }

  context 'instance' do
    subject(:book_card) { Fabricate('card/book') }

    its(:image) { should_not be_blank }
    its(:url) { should_not be_blank }
  end
end
