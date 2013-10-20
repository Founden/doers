require 'spec_helper'

describe Endorse do
  it { should validate_presence_of(:board) }
  it { should validate_presence_of(:topic) }
  it { should validate_presence_of(:card) }

  context 'instance' do
    let(:endorse) { Fabricate(:endorse) }

    subject { endorse }

    its(:slug) { should eq('create-endorse') }
    its(:type) { should eq(Endorse.name) }

    context 'on destroy', :use_truncation do
      before { endorse.destroy }

      its('card.activities.first.slug') { should eq('destroy-endorse') }
    end
  end
end
