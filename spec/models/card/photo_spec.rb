require 'spec_helper'

describe Card::Photo do
  it { should have_one(:image).dependent(:destroy) }
  it { should belong_to(:parent_card) }
  it { should have_many(:versions).dependent(:destroy) }

  context 'instance' do
    subject(:photo_card) { Fabricate('card/photo') }

    its(:image) { should_not be_blank }
  end
end
