require 'spec_helper'

feature 'Projects', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'creation screen' do
    given(:attrs) { Fabricate.attributes_for(:project) }
    given(:user) { User.first }

    background do
      visit root_path(:anchor => '/projects/new')
    end

    scenario 'form submission creates a new project' do
      within('#project-new') do
        fill_in :titleInput, :with => attrs[:title]
        fill_in :wwwInput, :with => attrs[:website]
        fill_in :descriptionInput, :with => attrs[:description]
      end

      click_on('project-save')

      sleep(1)
      expect(page).to have_css('#project.project-%d' % user.projects.first.id)
      expect(page).to have_content(attrs[:title])
      expect(page).to have_content(attrs[:description])
      expect(page).to have_content(URI.parse(attrs[:website]).hostname)
    end

    scenario 'with missing parameters creates a project with default values' do
      click_on('project-save')
      sleep(1)
      expect(user.projects.reload.count).to eq(1)
    end
  end
end
