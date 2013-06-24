require 'spec_helper'

describe Card::Options do
  let(:options_card) { Fabricate('card/options') }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:options) }

  context 'instance' do
    subject { options_card }

    its(:title) { should_not be_blank }
    its(:options) { should_not be_empty }

    context 'validates empty options' do
      let(:opts) { [ {:label => nil}.with_indifferent_access ] }
      before { options_card.options = opts }

      it { should_not be_valid }
    end

    context 'sanitizes #options' do
      let(:option_label) { Faker::HTMLIpsum.fancy_string }
      before do
        options = options_card.options
        options[0]['label'] = option_label
        options[0]['selected'] = option_label
        options_card.update_attributes(:options => options)
      end

      it 'without HTML' do
        options_card.options[0]["label"].should eq(Sanitize.clean(option_label))
        options_card.options[0]["selected"].should be_true
      end
    end

  end
end
