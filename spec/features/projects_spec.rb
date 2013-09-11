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

    scenario 'with a title and description set, creates a new project' do
      within('.project') do
        fill_in :title, :with => attrs[:title]
        fill_in :description, :with => attrs[:description]
      end

      click_on('create-project')

      sleep(1)
      expect(page).to have_css('#project-%d' % user.projects.first.id)
      expect(page).to have_field(:title, :with =>  attrs[:title])
      expect(page).to have_field(:description, :with => attrs[:description])
    end

    scenario 'with missing title wont show create button' do
      within('.project') do
        fill_in :title, :with => ''
        fill_in :description, :with => attrs[:description]
      end
      expect(page).to_not have_css('#create-project')
    end
  end
end
