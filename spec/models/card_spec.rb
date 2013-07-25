require 'spec_helper'

describe Card do
  let(:card) { Fabricate(:card) }

  it { should belong_to(:user) }
  it { should belong_to(:board) }
  it { should belong_to(:project) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:board) }
  it { should validate_inclusion_of(:style).in_array(Card::STYLES) }

  context 'instance' do
    subject { card }

    its(:position) { should eq(0) }

    context 'sanitizes' do
      let(:content) { Faker::HTMLIpsum.body }

      context '#title' do
        before { card.update_attributes(:title => content[0..250]) }

        its(:title) { should eq(Sanitize.clean(content[0..250])) }
      end

      context '#content' do
        before { card.update_attributes(:content => content) }

        its(:content) { should eq(Sanitize.clean(content)) }
      end
    end
  end
end
