require 'spec_helper'

feature 'Projects', :js, :slow, :vcr => {:cassette_name => :twitter_oauth} do

  background do
    sign_in_with_twitter
  end

  scenario 'user can access an existing project' do
    2.times { Fabricate(:project, :user => User.first) }

    visit root_path(:anchor => :dashboard)

    expect(page).to have_css('#projects .project', :count => 2)
  end


  scenario 'user creates a new project' do
    prj_attrs = Fabricate.attributes_for(:project)

    visit root_path(:anchor => :dashboard)

    expect(page).to have_css('#projects li', :count => 0)

    click_on('projects-add')
    fill_in('titleInput', :with => prj_attrs[:title])
    fill_in('descriptionInput', :with => prj_attrs[:description])
    click_on('projects-save')
    visit root_path(:anchor => :dashboard)

    expect(page).to have_css('#projects .project', :count => 1)
  end

  scenario 'user can access an existing project' do
    projects = 2.times.collect { Fabricate(:project, :user => User.first) }

    visit root_path(:anchor => :dashboard)
    find('#project-%d a' % projects.first.id).click

    expect(page).to have_content(projects.first.title)
    expect(page).to have_content(projects.first.description)
    expect(page).to have_content(projects.first.user.nicename)
  end
end
