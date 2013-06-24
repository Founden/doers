require 'spec_helper'

describe Card do
  let(:card) { Fabricate(:card) }

  it { should belong_to(:user) }
  it { should belong_to(:board) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:board) }
  it { should serialize(:data) }

  context 'instance' do
    subject { card }

    its(:position) { should eq(0) }
    its(:data) { should be_empty }

    context 'sanitizes #title' do
      let(:content) { Faker::HTMLIpsum.body }
      before { card.update_attributes(:title => content) }

      its(:title) { should eq(Sanitize.clean(content)) }
    end
  end
end
