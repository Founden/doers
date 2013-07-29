require 'spec_helper'

describe Card::Link do
  let(:link_card) { Fabricate('card/link') }

  it { should validate_presence_of(:content) }
  it { should allow_value(Faker::Internet.uri(:http)).for(:content) }
  it { should allow_value(Faker::Internet.uri(:https)).for(:content) }

  context 'instance' do
    subject { link_card }

    its(:content) { should_not be_blank }
  end
end
