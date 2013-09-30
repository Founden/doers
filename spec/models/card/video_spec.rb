require 'spec_helper'

describe Card::Video do
  it { should have_one(:image).dependent(:destroy) }
  it { should validate_presence_of(:video_id) }
  it { should validate_presence_of(:provider) }
  it { should allow_value(Card::Video::PROVIDERS.sample).for(:provider) }
  it { should_not allow_value(Faker::Lorem.word).for(:provider) }

  context 'instance' do
    subject(:photo_card) { Fabricate('card/photo') }

    its(:image) { should_not be_blank }
  end
end
