require 'spec_helper'

describe Card::Phrase do
  it { should belong_to(:parent_card) }
  it { should have_many(:versions).dependent(:destroy) }
  it { should validate_presence_of(:content) }

  context 'instance' do
    subject(:phrase_card) { Fabricate('card/phrase') }

    its(:content) { should_not be_blank }
  end
end
