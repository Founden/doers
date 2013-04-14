require 'spec_helper'

describe Field::Options do
  let(:options_field) { Fabricate('field/options') }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:options) }

  context 'instance' do
    subject { options_field }

    its(:title) { should_not be_blank }
    its(:options) { should_not be_empty }

    context 'validates empty options' do
      let(:opts) { [ {:label => nil}.with_indifferent_access ] }
      before { options_field.options = opts }

      it { should_not be_valid }
    end

    context 'sanitizes #options' do
      let(:option_label) { Faker::HTMLIpsum.fancy_string }
      before do
        options = options_field.options
        options[0]['label'] = option_label
        options[0]['selected'] = option_label
        options_field.update_attributes(:options => options)
      end

      it 'without HTML' do
        options_field.options[0]["label"].should eq(Sanitize.clean(option_label))
        options_field.options[0]["selected"].should be_true
      end
    end

  end
end
