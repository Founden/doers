require 'spec_helper'

describe Card::Numerics do
  let(:numerics_card) { Fabricate('card/numerics') }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:minimum) }
  it { should validate_presence_of(:maximum) }
  it { should validate_presence_of(:selected) }

  it { should validate_numericality_of(:minimum) }
  it { should validate_numericality_of(:maximum) }
  it { should validate_numericality_of(:selected) }

  context 'instance' do
    subject { numerics_card }

    its(:minimum) { should be < numerics_card.maximum }
    its(:maximum) { should be > numerics_card.minimum }
    its(:selected) { should be <= numerics_card.maximum }
    its(:selected) { should be >= numerics_card.minimum }

    context 'validates minimum, maximum and selected values' do
      before { numerics_card.minimum = numerics_card.maximum }

      it{ should_not be_valid }
    end
  end
end
