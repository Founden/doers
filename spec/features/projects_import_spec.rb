require 'spec_helper'

feature 'Projects', :js, :slow, :pending do
  background do
    sign_in_with_angel_list
  end

  context 'user with Angel List startups' do
    given(:startups) do
      MultiJson.load(Rails.root.join('spec/fixtures/angel_list_startups.json'))
    end
    given(:startup) { startups['startup_roles'][3]['startup'] }

    background do
      Delayed::Job.stub(:enqueue)
      proxy.stub(/startup_roles/).and_return(:jsonp => startups)
    end

    context 'sees import screen' do
      background do
        visit root_path
        click_on('projects-import')
      end

      scenario 'with startups' do
        expect(page).to have_css('.project-item', :count => 2)
      end

      scenario 'with an importer running message after import starts' do
        find('.startup-%d' % startup['id']).click
        expect(page).to have_css('.project-item.selected', :count => 1)

        find('#run-import').click

        expect(page).to_not have_css('.project-list')
        expect(page).to have_css('.status')
      end
    end
  end

  context 'user with no Angel List startups' do
    background do
      proxy.stub(/startup_roles/).and_return(:jsonp => [])
    end

    context 'sees import screen' do
      background do
        visit root_path
        click_on('projects-import')
      end

      scenario 'empty' do
        expect(page).to have_css('.project-item', :count => 0)
      end
    end
  end
end
