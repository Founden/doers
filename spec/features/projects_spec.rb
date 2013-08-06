require 'spec_helper'

feature 'Projects', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'creation screen' do
    given(:attrs) { Fabricate.attributes_for(:project) }
    given(:user) { User.first }

    background do
      visit root_path(:anchor => 'projects/new')
    end

    scenario 'form submission creates a new project' do
      within('#project-new') do
        fill_in :titleInput, :with => attrs[:title]
        fill_in :wwwInput, :with => attrs[:website]
        fill_in :descriptionInput, :with => attrs[:description]
      end

      click_on('project-save')

      expect(page).to have_css('#projects .project')
      expect(page).to have_content(attrs[:title])
      expect(page).to have_content(attrs[:description])
      expect(page).to have_content(URI.parse(attrs[:website]).hostname)
    end

    scenario 'form submission with missing parameters shows an error' do
      within('#project-new') do
        fill_in :titleInput, :with => title
      end

      click_on('project-save')

      expect(page).to have_css('#notifications .alert-box.alert')
      expect(user.projects.count).to eq(0)
    end
  end
end
