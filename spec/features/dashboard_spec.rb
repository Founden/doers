require 'spec_helper'

feature 'Dashboard', :js, :slow, :vcr => {:cassette_name=>:angel_list_oauth2} do

  background do
    sign_in_with_angel_list
  end

  scenario 'user with no projects can import or create one' do
    visit root_path(:anchor => :dashboard)

    expect(page).to have_css('#projects-import')
    expect(page).to have_css('#projects-add')
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

end
