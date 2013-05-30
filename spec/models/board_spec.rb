require 'spec_helper'

describe Board do
  let(:board) { Fabricate(:board) }

  it { should belong_to(:user) }
  it { should belong_to(:project) }
  it { should have_many(:fields) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:title) }
  it { should ensure_inclusion_of(:status).in_array(Board::STATES) }

  context 'instance' do
    subject { board }

    its(:status) { should eq(Board::STATES.first) }
    its(:position) { should eq(0) }
  end
end
