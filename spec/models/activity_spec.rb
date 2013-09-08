require 'spec_helper'

describe Activity, :use_truncation do
  it { should belong_to(:user) }
  it { should belong_to(:board) }
  it { should belong_to(:project) }
  it { should belong_to(:trackable) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:trackable_id) }
  it { should validate_presence_of(:trackable_type) }
  it { should validate_presence_of(:slug) }

  context 'caches name' do
    let(:user) { Fabricate(:user) }
    let!(:trackable) { user }

    subject { trackable.activities.first }

    its(:user_name) { should eq(user.nicename) }
    its(:trackable_title) { should be_nil }
    its(:comment_id) { should be_nil }

    context 'and title' do
      let(:project) { Fabricate(:project, :user => user) }
      let(:trackable) { project }

      subject { project.activities.first }

      its(:user_name) { should eq(user.nicename) }
      its(:project) { should eq(project) }
      its(:trackable_title) { should eq(project.title) }
    end
  end
end
