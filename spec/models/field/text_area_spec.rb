require 'spec_helper'

describe Field::TextArea do
  let(:text_area_field) { Fabricate('field/text_area') }

  it { should validate_presence_of(:content) }

  context 'instance' do
    subject { text_area_field }

    its(:content) { should_not be_blank }

    context 'sanitizes #content' do
      let(:content) { Faker::HTMLIpsum.body }
      before { text_area_field.update_attributes(:content => content) }

      its(:content) {
        should eq(Sanitize.clean(content, Sanitize::Config::BASIC)) }
    end

  end
end
