require 'spec_helper'

describe Api::V1::ProjectsController do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    let(:project_ids) { [] }
    let(:user) { Fabricate(:user_with_projects, :projects_count => 2) }

    subject(:api_projects) { json_to_ostruct(response.body) }

    context 'when no project ids are queried' do
      before { get(:index, :ids => project_ids) }

      its('projects.count') { should eq(0) }
    end

    context 'when project ids are queried' do
      let(:project_ids) { user.projects.pluck('id') }

      before { get(:index, :ids => project_ids) }

      its('projects.count') { should eq(user.projects.count) }
    end

    context 'when project ids are not available' do
      let(:project_ids) { [Fabricate(:project).id] }

      it 'raises not found' do
        expect{
          get(:index, :ids => project_ids)
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe '#show' do
    let(:prj) { Fabricate(:project, :user => user) }

    before { get(:show, :id => prj.id) }

    subject(:api_project) { json_to_ostruct(response.body, :project) }

    its('keys.count') { should eq(15) }
    its(:id){ should eq(prj.id) }
    its(:title) { should eq(prj.title) }
    its(:description) { should eq(prj.description) }
    its(:status) { should eq(prj.status) }
    its(:updated_at) { should_not be_blank }
    its(:last_update) { should eq(prj.updated_at.to_s(:pretty)) }
    its(:user_id) { should eq(user.id) }
    its(:website) { should eq(prj.website) }
    its(:logo_id) { should eq(prj.logo.id) }
    its(:board_ids) { should be_empty }
    its('activity_ids.size') { should eq(prj.activities.count) }
    its('membership_ids.size') { should eq(prj.memberships.count) }
    its(:boards_count) { should eq(prj.boards.count) }
    its(:members_count) { should eq(prj.members.count) }
    its('invitation_ids.count') { should eq(prj.invitations.count) }

    context 'for a project with boards' do
      let(:prj) { Fabricate(:project_with_boards, :user => user) }

      its('keys.count') { should eq(15) }
      its('board_ids.size') { should eq(prj.boards.count) }
      its('board_ids.sort') { should eq(prj.boards.map(&:id).sort) }
    end
  end

  describe '#create' do
    let(:prj_attrs) { Fabricate.attributes_for(:project) }
    before { post(:create, :project => prj_attrs) }

    subject(:api_project) { json_to_ostruct(response.body, :project) }

    its('keys.count') { should eq(15) }
    its(:id) { should_not be_nil }
    its(:title) { should eq(prj_attrs['title']) }
    its(:description) { should eq(prj_attrs['description']) }
    its(:status) { should eq(Project::STATES.first) }
    its(:user_id) { should eq(user.id) }
    its(:board_ids) { should be_empty }

    context 'except on wrong arguments' do
      let( :prj_attrs ) { {:project => {:title => ''} } }

      subject(:api_project) { json_to_ostruct(response.body) }

      its('keys.count') { should eq(1) }
      its('errors.size') { should eq(1) }
      its('errors.keys') { should include('title') }
    end
  end

  describe '#update' do
    let(:prj) { Fabricate(:project, :user => user) }
    let(:prj_attrs) do
      Fabricate.attributes_for(:project, :status => Project::STATES.last)
    end

    before { post(:update, :id => prj.id, :project => prj_attrs) }

    subject(:api_project) { json_to_ostruct(response.body, :project) }

    its('keys.count') { should eq(15) }
    its(:id) { should eq(prj.id) }
    its(:title) { should eq(prj_attrs['title']) }
    its(:description) { should eq(prj_attrs['description']) }
    its(:website) { should eq(prj_attrs['website']) }
    its(:user_id) { should eq(user.id) }
    its(:board_ids) { should be_empty }
    its(:invitation_ids) { should be_empty }
  end

  describe '#destroy' do
    let(:project) { Fabricate(:project, :user => user) }
    let(:project_id) { project.id }

    before { delete(:destroy, :id => project_id) }

    its('response.status') { should eq(204) }
    its('response.body') { should be_blank }

    context 'project is not owned by current user' do
      let(:project_id) { rand(999..9999) }

      its('response.status') { should eq(400) }
    end
  end

end
