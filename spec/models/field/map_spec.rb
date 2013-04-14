require 'spec_helper'

describe Field::Map do
  let(:map_field) { Fabricate('field/map') }

  it { should validate_presence_of(:location) }
  it { should validate_presence_of(:address) }

  context 'instance' do
    subject { map_field }

    its(:location) { should_not be_blank }
    its(:address) { should_not be_blank }
  end
end
