require 'spec_helper'

describe Panel do
  let(:panel) { Fabricate(:panel) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:label) }
  it { should ensure_inclusion_of(:status).in_array(Panel::STATES) }

  context 'instance' do
    subject { panel }

    its(:status) { should eq(Panel::STATES.first) }
    its(:position) { should eq(0) }
  end
end
