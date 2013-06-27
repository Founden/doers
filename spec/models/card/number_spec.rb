require 'spec_helper'

describe Card::Number do

  it { should validate_presence_of(:content) }
  it { should validate_numericality_of(:content) }

  context 'instance' do
    subject(:number_card) { Fabricate('card/number') }

    its(:content) { should be_a Float }
  end
end
