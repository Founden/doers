require 'spec_helper'

describe Card::Text do
  let(:text_card) { Fabricate('card/text') }

  it { should validate_presence_of(:content) }

  context 'instance' do
    subject { text_card }

    its(:content) { should_not be_blank }
  end
end
