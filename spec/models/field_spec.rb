require 'spec_helper'

describe Field do
  let(:field) { Fabricate(:field) }

  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }
  it { should serialize(:data) }

  context 'instance' do
    subject { field }

    its(:position) { should eq(0) }
    its(:data) { should be_empty }
  end
end
