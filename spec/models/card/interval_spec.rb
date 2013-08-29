require 'spec_helper'

describe Card::Interval do
  it { should belong_to(:parent_card) }
  it { should have_many(:versions).dependent(:destroy) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:minimum) }
  it { should validate_presence_of(:maximum) }

  it { should validate_numericality_of(:minimum) }
  it { should validate_numericality_of(:maximum) }
  it { should validate_numericality_of(:selected) }

  context 'instance' do
    let(:interval_card) { Fabricate('card/interval') }

    subject { interval_card }

    its(:minimum) { should be < interval_card.maximum }
    its(:maximum) { should be > interval_card.minimum }
    its(:selected) { should be <= interval_card.maximum }
    its(:selected) { should be >= interval_card.minimum }

    context 'validates minimum, maximum and selected values' do
      before { interval_card.minimum = interval_card.maximum }

      it{ should_not be_valid }
    end

    context 'validates minimum, maximum and selected if set' do
      before { interval_card.selected = nil }

      it{ should be_valid }
    end
  end
end
