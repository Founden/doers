require 'spec_helper'

describe Field::Text do
  let(:text_field) { Fabricate('field/text') }

  it { should validate_presence_of(:content) }

  context 'instance' do
    subject { text_field }

    its(:content) { should_not be_blank }
  end
end
