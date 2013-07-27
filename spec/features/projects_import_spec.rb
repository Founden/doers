require 'spec_helper'

feature 'Projects', :js, :slow, :vcr do
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

    context 'on import screen' do
      background do
        visit root_path(:anchor => :dashboard)
        click_on('projects-import')
      end

      scenario 'are listed' do
        expect(page).to have_css('.projects .project', :count => 2)
      end

      scenario 'after import shows importer running screen' do
        # Pick 3rd startup where role is `founder`
        find('.startup-%d' % startup['id']).click
        expect(page).to have_css('.projects .project.selected', :count => 1)

        click_on('run-import')

        expect(page).to_not have_css('#importer')
        expect(page).to have_css('#importer-running')
      end
    end
  end

  context 'user with no Angel List startups' do
    background do
      proxy.stub(/startup_roles/).and_return(:jsonp => [])
    end

    context 'on import screen' do
      background do
        visit root_path(:anchor => :dashboard)
        click_on('projects-import')
      end

      scenario 'none are listed' do
        expect(page).to have_css('.projects .project', :count => 0)
      end
    end
  end
end
