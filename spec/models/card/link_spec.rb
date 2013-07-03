require 'spec_helper'

describe Card::Link do
  let(:link_card) { Fabricate('card/link') }

  it { should validate_presence_of(:excerpt) }
  it { should allow_value(Faker::Internet.uri(:http)).for(:url) }
  it { should allow_value(Faker::Internet.uri(:https)).for(:url) }
  it { should_not allow_value(Faker::Lorem.sentence).for(:url) }

  context 'instance' do
    subject { link_card }

    its(:url) { should_not be_blank }
  end
end
