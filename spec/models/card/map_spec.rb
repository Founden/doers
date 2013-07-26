require 'spec_helper'

describe Card::Map do
  let(:map_card) { Fabricate('card/map') }

  it { should validate_presence_of(:content) }

  context 'instance' do
    subject { map_card }

    its(:content) { should_not be_blank }
  end
end
