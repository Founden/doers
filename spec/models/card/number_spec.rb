require 'spec_helper'

describe Card::Number do

  it { should validate_presence_of(:number) }
  it { should validate_numericality_of(:number) }

  context 'instance' do
    subject(:number_card) { Fabricate('card/number') }

    its(:number) { should be_a Float }
  end
end
