require 'spec_helper'

describe Project, :use_truncation do
  let(:user) { Fabricate(:user) }
  let!(:project) { Fabricate(:project, :user => user) }

  context '#activities' do
    subject(:activities) { project.activities }

    context 'on create' do
      subject{ activities.first }

      it { activities.count.should eq(1) }
      its(:user) { should eq(project.user) }
      its(:project) { should eq(project) }
      its(:slug) { should eq('create-project') }
    end

    context 'on update' do
      before { project.update_attributes(:title => Faker::Company.name) }

      subject{ activities.last }

      it { activities.count.should eq(2) }
      its(:user) { should eq(project.user) }
      its(:project) { should eq(project) }
      its(:slug) { should eq('update-project') }
    end

    context 'on delete' do
      before { project.destroy }

      subject { user.activities.last }

      it { activities.count.should eq(2) }
      its(:user) { should eq(user) }
      its(:project_id) { should_not be_nil }
      its(:slug) { should eq('destroy-project') }
    end
  end
end
