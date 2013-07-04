require 'spec_helper'

describe Api::V1::ProjectsController do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    before do
      2.times { Fabricate(:project, :user => user) }
      get(:index)
    end

    it 'serializes current user projects list into a json' do
      projects = JSON.parse(response.body)['projects']
      projects.count.should eq(2)
    end
  end

  describe '#show' do
    let(:prj) { Fabricate(:project, :user => user) }

    before { get(:show, :id => prj.id) }

    it 'serializes user project into a json' do
      api_project = JSON.parse(response.body)['project']
      api_project.keys.count.should eq(9)

      project = user.projects.first

      api_project['id'].should eq(project.id)
      api_project['title'].should eq(project.title)
      api_project['description'].should eq(project.description)
      api_project['status'].should eq(project.status)
      api_project['updated_at'].should_not be_blank
      api_project['user_id'].should eq(user.id)
      api_project['website'].should eq(project.website)
      api_project['logo_url'].should eq(project.logo.attachment.url)
      api_project['board_ids'].should be_empty
    end

    context 'for a project with boards' do
      let(:prj) { Fabricate(:project_with_boards, :user => user) }

      it 'includes serialized boards into response' do
        api_project = JSON.parse(response.body)['project']
        api_project.keys.count.should eq(9)
        api_project['board_ids'].size.should eq(prj.boards.count)
        api_project['board_ids'].should eq(prj.boards.map(&:id))
      end
    end
  end

  describe '#create' do
    let(:prj_attrs) { Fabricate.attributes_for(:project) }
    before { post(:create, :project => prj_attrs) }

    it 'creates a project and serializes it to json' do
      project = JSON.parse(response.body)['project']
      project.keys.count.should eq(9)

      project['id'].should_not be_nil
      project['title'].should eq(prj_attrs['title'])
      project['description'].should eq(prj_attrs['description'])
      project['status'].should eq(Project::STATES.first)
      project['user_id'].should eq(user.id)
      project['board_ids'].should be_empty
    end

    context 'except on wrong arguments' do
      let( :prj_attrs ) { {:project => {:title => ''} } }

      it 'returns errors' do
        project = JSON.parse(response.body)
        project.keys.count.should eq(1)
        project['errors']['title'].should_not be_blank
      end
    end
  end

  describe '#update' do
    let(:prj) { Fabricate(:project, :user => user) }
    let(:prj_attrs) do
      Fabricate.attributes_for(:project, :status => Project::STATES.last)
    end

    before { post(:update, :id => prj.id, :project => prj_attrs) }

    it 'creates a project and serializes it to json' do
      project = JSON.parse(response.body)['project']
      project.keys.count.should eq(9)

      project['id'].should eq(prj.id)
      project['title'].should eq(prj_attrs['title'])
      project['description'].should eq(prj_attrs['description'])
      project['status'].should eq(Project::STATES.last)
      project['user_id'].should eq(user.id)
      project['board_ids'].should be_empty
    end
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
