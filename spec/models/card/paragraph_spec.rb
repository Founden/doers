require 'spec_helper'

describe Card::Paragraph do
  it { should belong_to(:parent_card) }
  it { should have_many(:versions).dependent(:destroy) }
  it { should validate_presence_of(:content) }

  context 'instance' do
    subject(:paragraph_card) { Fabricate('card/paragraph') }

    its(:content) { should_not be_blank }

    context 'sanitizes #content' do
      let(:content) { Faker::HTMLIpsum.body }
      before { paragraph_card.update_attributes(:content => content) }

      its(:content) {
        should eq(Sanitize.clean(content)) }
    end

  end
end
