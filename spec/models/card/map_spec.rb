require 'spec_helper'

describe Card::Map do
  it { should validate_presence_of(:content) }

  context 'instance' do
    subject { Fabricate('card/map') }

    its(:content) { should_not be_blank }
  end
end
