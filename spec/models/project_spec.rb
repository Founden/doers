require 'spec_helper'

describe Project do
  let(:project) { Fabricate(:project) }

  it { should belong_to(:user) }
  it { should have_many(:personas).dependent('') }
  it { should have_many(:problems).dependent('') }
  it { should have_many(:solutions).dependent('') }
  it { should have_many(:fields).dependent('') }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:title) }
  it { should ensure_inclusion_of(:status).in_array(Project::STATES) }

  context 'instance' do
    subject { project }

    its(:status) { should eq(Project::STATES.first) }
  end
end
