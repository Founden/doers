require 'spec_helper'

describe Project, :use_truncation do
  let(:user) { Fabricate(:user) }
  let!(:project) { Fabricate(:project, :user => user) }

  context '#activities' do
    subject { project.activities }

    context 'on create' do
      its(:size) { should eq(1) }
      its('first.user') { should eq(project.user) }
      its('first.trackable') { should eq(project) }
      its('first.slug') { should match('create-project') }
    end

    context 'on update' do
      before { project.update_attributes(:title => Faker::Company.name) }

      its(:size) { should eq(2) }
      its('last.user') { should eq(project.user) }
      its('last.project') { should eq(project) }
      its('last.trackable') { should eq(project) }
      its('last.slug') { should match('update-project') }
    end

    context 'on delete' do
      before { project.destroy }

      subject { user.activities }

      its(:size) { should eq(3) }
      its('last.user') { should eq(user) }
      its('last.project_id') { should_not be_nil }
      its('last.trackable_id') { should_not be_nil }
      its('last.trackable_type') { should eq(Project.name) }
      its('last.slug') { should match('destroy-project') }
    end
  end
end
