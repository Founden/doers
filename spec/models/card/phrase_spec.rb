require 'spec_helper'

describe Card::Phrase do
  it { should validate_presence_of(:content) }

  context 'instance' do
    subject(:phrase_card) { Fabricate('card/phrase') }

    its(:content) { should_not be_blank }
  end
end
