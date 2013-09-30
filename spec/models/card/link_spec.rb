require 'spec_helper'

describe Card::Link do
  it { should validate_presence_of(:content) }
  it { should allow_value(Faker::Internet.uri(:http)).for(:url) }
  it { should allow_value(Faker::Internet.uri(:https)).for(:url) }
  it { should_not allow_value(Faker::Lorem.sentence).for(:url) }

  context 'instance' do
    subject { Fabricate('card/link') }

    its(:url) { should_not be_blank }
  end
end
