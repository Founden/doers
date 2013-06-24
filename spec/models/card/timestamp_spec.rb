require 'spec_helper'

describe Card::Timestamp do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:timestamp) }

  context 'instance' do
    subject do
      Fabricate.build('card/timestamp', :timestamp => Faker::Lorem.word)
    end

    context 'validates timestamp as a date' do
      it { should_not be_valid }
    end

  end
end
