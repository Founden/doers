require 'spec_helper'

feature 'Dashboard', :js, :slow, :vcr => {:cassette_name => :twitter_oauth} do

  background do
    sign_in_with_twitter
  end

  scenario 'user can see the dashboard' do
    visit root_path(:anchor => :dashboard)

    expect(page).to have_css('#projects')
  end
end
