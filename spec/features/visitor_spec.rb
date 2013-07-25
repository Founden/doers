require 'spec_helper'

feature 'Visitor', :js, :slow do

  scenario 'is asked to sign in before accessing a non-public page' do
    visit dashboard_pages_path

    current_path.should eq(sign_in_path)
  end
end
