require 'spec_helper'

describe Card::TextArea do
  let(:text_area_card) { Fabricate('card/text_area') }

  it { should validate_presence_of(:content) }

  context 'instance' do
    subject { text_area_card }

    its(:content) { should_not be_blank }

    context 'sanitizes #content' do
      let(:content) { Faker::HTMLIpsum.body }
      before { text_area_card.update_attributes(:content => content) }

      its(:content) {
        should eq(Sanitize.clean(content)) }
    end

  end
end
