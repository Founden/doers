require 'spec_helper'

feature 'Dashboard', :js, :slow, :vcr => {:cassette_name => :twitter_oauth} do

  background do
    sign_in_with_twitter
  end

  scenario 'when logged in user can see the dashboard' do
    visit "/#dashboard"

    expect(page.source).to match('id="projects')
    # TODO: Capybara is blind on ID's
    # expect(page).to have_css('#projects')
  end
end
