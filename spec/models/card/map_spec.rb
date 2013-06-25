require 'spec_helper'

describe Card::Map do
  let(:map_card) { Fabricate('card/map') }

  it { should validate_presence_of(:location) }
  it { should validate_presence_of(:address) }

  context 'instance' do
    subject { map_card }

    its(:location) { should_not be_blank }
    its(:address) { should_not be_blank }
  end
end
