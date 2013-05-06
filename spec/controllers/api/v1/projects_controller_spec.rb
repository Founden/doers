require 'spec_helper'

describe Api::V1::ProjectsController do
  let(:user) { Fabricate(:user) }

  before do
    2.times { Fabricate(:project, :user => user) }
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    before { get(:index) }

    it 'serializes current user projects list into a json' do
      projects = JSON.parse(response.body)['projects']
      projects.count.should eq(2)
    end
  end

  describe '#show' do
    before { get(:show, :id => user.projects.reload.first.id) }

    it 'serializes user project into a json' do
      api_project = JSON.parse(response.body)['project']
      api_project.keys.count.should eq(6)

      project = user.projects.first

      api_project['id'].should eq(project.id)
      api_project['title'].should eq(project.title)
      api_project['description'].should eq(project.description)
      api_project['status'].should eq(project.status)
      api_project['updated_at'].should_not be_blank
      api_project['user_id'].should eq(user.id)
    end
  end

  describe '#create' do
    let(:prj_attrs) { Fabricate.attributes_for(:project) }
    before { post(:create, :project => prj_attrs) }

    it 'creates a project and serializes it to json' do
      project = JSON.parse(response.body)['project']
      project.keys.count.should eq(6)

      project['id'].should_not be_nil
      project['title'].should eq(prj_attrs['title'])
      project['description'].should eq(prj_attrs['description'])
      project['status'].should eq(Project::STATES.first)
      project['user_id'].should eq(user.id)
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
      project.keys.count.should eq(6)

      project['id'].should eq(prj.id)
      project['title'].should eq(prj_attrs['title'])
      project['description'].should eq(prj_attrs['description'])
      project['status'].should eq(Project::STATES.last)
      project['user_id'].should eq(user.id)
    end
  end

end
