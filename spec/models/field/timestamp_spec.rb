require 'spec_helper'

describe Field::Timestamp do
  let(:ts_field) { Fabricate('field/timestamp') }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:timestamp) }

  context 'instance' do
    subject { ts_field }

    context 'validates timestamp as a date' do
      before { ts_field.timestamp = Faker::Lorem.word }

      it { should_not be_valid }
    end

  end
end
