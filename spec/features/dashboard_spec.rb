require 'spec_helper'

feature 'Dashboard', :js, :slow, :vcr => {:cassette_name=>:angel_list_oauth2} do

  background do
    sign_in_with_angel_list
  end

  scenario 'user can see the dashboard' do
    visit root_path(:anchor => :dashboard)

    expect(page).to have_css('#projects')
  end
end
