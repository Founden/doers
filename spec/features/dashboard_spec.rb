require 'spec_helper'

feature 'Dashboard', :js, :slow do

  background do
    sign_in_with_angel_list
  end

  context 'menu' do
    background do
      visit root_path
      page.execute_script('if (localStorage) localStorage.clear()')
    end

    scenario 'is expanded' do
      expect(page).to have_css('.nav.narrow', :count => 0)
      expect(page).to have_css('.content.wide', :count => 0)
    end

    context 'on toggle' do
      background do
        page.find('.nav-toggle').click
      end

      scenario 'narrows the menu and expands the content' do
        expect(page).to have_css('.nav.narrow', :count => 1)
        expect(page).to have_css('.content.wide', :count => 1)
      end

      scenario 'menu state persists on page reload' do
        visit root_path
        expect(page).to have_css('.nav.narrow', :count => 1)
        expect(page).to have_css('.content.wide', :count => 1)
      end
    end
  end

  context 'with no projects' do
    background do
      visit root_path
    end

    scenario 'has no projects listed' do
      expect(page).to have_css('.project-item', :count => 0)
    end

    scenario 'has an import project button' do
      expect(page).to have_css('#projects-import')
    end

    scenario 'has a create project button' do
      expect(page).to have_css('#projects-add')
    end
  end

  context 'with projects' do
    given(:user) { User.first }

    background do
      3.times { Fabricate(:project, :user => user) }
      visit root_path
    end

    scenario 'is shown with add and import buttons' do
      expect(page).to have_css('#projects-import')
      expect(page).to have_css('#projects-add')
    end

    scenario 'shows available projects' do
      expect(page).to have_css(
        '.project-item', :count => user.projects.count)
    end

    scenario 'includes project details' do
      user.projects.each do |prj|
        expect(page).to have_content(prj.title)
        # expect(page).to have_content(prj.description)
        # expect(page).to have_content(URI.parse(prj.website).hostname)
        # expect(page.source).to include(
        #   prj.logo.attachment.url.force_encoding('UTF-8'))
      end
    end

    scenario 'goes to the project boards when clicked one' do
      find('#project-%d .project-item-title' % user.projects.first.id).click

      expect(page).to have_content(user.projects.first.title)
    end

    scenario 'confirms deletion and removes project when clicked on delete' do
      pending
      find('#project-%d .delete-button' % user.projects.first.id).click
      expect(page).to have_css('.delete-confirmation')
      find('.delete-confirmation .button.red').click
      sleep(1)
      expect(page).to have_css(
        '.projects .project', :count => user.projects.count)
    end

  end
end
