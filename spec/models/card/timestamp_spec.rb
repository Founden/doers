require 'spec_helper'

describe Card::Timestamp do
  it { should belong_to(:parent_card) }
  it { should have_many(:versions).dependent(:destroy) }
  it { should validate_presence_of(:content) }

  context 'instance' do
    subject do
      Fabricate.build('card/timestamp', :content => Faker::Lorem.word)
    end

    context 'validates #content as a date' do
      it { should_not be_valid }
    end

  end
end
