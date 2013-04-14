require 'spec_helper'

describe Field::Numerics do
  let(:numerics_field) { Fabricate('field/numerics') }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:minimum) }
  it { should validate_presence_of(:maximum) }
  it { should validate_presence_of(:selected) }

  it { should validate_numericality_of(:minimum) }
  it { should validate_numericality_of(:maximum) }
  it { should validate_numericality_of(:selected) }

  context 'instance' do
    subject { numerics_field }

    its(:minimum) { should be < numerics_field.maximum }
    its(:maximum) { should be > numerics_field.minimum }
    its(:selected) { should be < numerics_field.maximum }
    its(:selected) { should be > numerics_field.minimum }

    context 'zeroes wrong values if any' do
      before { numerics_field.minimum = numerics_field.maximum }

      it{ should_not be_valid }
    end
  end
end
