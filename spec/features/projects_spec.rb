require 'spec_helper'

feature 'Projects', :js, :no_ci, :vcr => {:cassette_name=>:angel_list_oauth2} do
  background do
    sign_in_with_angel_list
  end

  scenario 'user can create a project' do
    prj_attrs = Fabricate.attributes_for(:project)
    visit root_path(:anchor => 'projects/new')

    within('#project-new') do
      fill_in :titleInput, :with => prj_attrs[:title]
      fill_in :wwwInput, :with => prj_attrs[:website]
      fill_in :descriptionInput, :with => prj_attrs[:description]
    end

    click_on('project-save')

    expect(page).to have_css('#projects .project')
    expect(page).to have_content(prj_attrs[:title])
  end

  scenario 'user can not create a project if attributes are missing' do
    title = Faker::Lorem.word
    visit root_path(:anchor => 'projects/new')

    within('#project-new') do
      fill_in :titleInput, :with => title
    end

    click_on('project-save')

    expect(page).to have_css('#notifications .alert-box.alert')
    visit root_path(:anchor => 'dashboard')
    expect(page).to_not have_content(title)
  end


  scenario 'user can access an existing project' do
    2.times { Fabricate(:project, :user => User.first) }

    visit root_path(:anchor => :dashboard)

    expect(page).to have_css('#projects .project', :count => 2)
  end


  scenario 'user can access an existing project' do
    projects = 2.times.collect { Fabricate(:project, :user => User.first) }

    visit root_path(:anchor => :dashboard)
    find('#project-%d a' % projects.first.id).click

    expect(page).to have_content(projects.first.title)
  end

  context 'importer for Angel List projects' do
    given(:startups) do
      MultiJson.load(Rails.root.join('spec/fixtures/angel_list_startups.json'))
    end
    given(:startup) { startups['startup_roles'][3]['startup'] }

    background do
      Delayed::Job.stub(:enqueue)
      proxy.stub(/startup_roles/).and_return(:jsonp => startups)
    end

    scenario 'are rendered and can be selected' do
      visit root_path(:anchor => :dashboard)

      click_on('projects-import')
      expect(page).to have_css('.projects .project', :count => 2)

      # Pick 3rd startup where role is `founder`
      find('.startup-%d' % startup['id']).click
      expect(page).to have_css('.projects .project.selected', :count => 1)

      click_on('run-import')

      expect(page).to_not have_css('#importer')
      expect(page).to have_css('#importer-running')
    end
  end
end
