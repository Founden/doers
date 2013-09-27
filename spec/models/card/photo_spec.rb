require 'spec_helper'

describe Card::Photo do
  it { should have_one(:image).dependent(:destroy) }

  context 'instance' do
    subject(:photo_card) { Fabricate('card/photo') }

    its(:image) { should_not be_blank }
  end
end
