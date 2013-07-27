require 'spec_helper'

feature 'Dashboard', :js, :slow, :vcr do

  background do
    sign_in_with_angel_list
  end

  context 'with no projects' do
    background do
      visit root_path(:anchor => :dashboard)
    end

    scenario 'is shown with add and import buttons' do
      expect(page).to have_css('#projects-import')
      expect(page).to have_css('#projects-add')

      expect(page).to have_css('.projects .project', :count => 0)
    end
  end

  context 'with projects' do
    given(:user) { User.first }

    background do
      3.times { Fabricate(:project, :user => user) }
      visit root_path(:anchor => :dashboard)
    end

    scenario 'is shown with add and import buttons' do
      expect(page).to have_css('#projects-import')
      expect(page).to have_css('#projects-add')
    end

    scenario 'includes projects list' do
      expect(page).to have_css(
        '.projects .project', :count => user.projects.count)
    end

    scenario 'includes project details' do
      user.projects.each do |prj|
        expect(page).to have_content(prj.title)
        expect(page.source).to include(prj.logo.attachment.url)
      end
    end

    scenario 'goes to the project boards when clicked one' do
      find('#project-%d a' % user.projects.first.id).click

      expect(page).to have_content(user.projects.first.title)
    end

  end
end
