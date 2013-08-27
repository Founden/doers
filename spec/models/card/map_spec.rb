require 'spec_helper'

describe Card::Map do
  it { should belong_to(:parent_card) }
  it { should have_many(:versions).dependent(:destroy) }
  it { should validate_presence_of(:content) }

  context 'instance' do
    subject { Fabricate('card/map') }

    its(:content) { should_not be_blank }
  end
end
