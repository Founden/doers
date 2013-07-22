require 'spec_helper'

feature 'Boards', :js, :slow, :vcr => {:cassette_name=>:angel_list_oauth2} do
  background do
    sign_in_with_angel_list
  end

  scenario 'user can access an existing board' do
     project = Fabricate(:project_with_boards, :user => User.first)

     visit root_path(:anchor => 'projects/%d' % project.id)

     expect(page).to have_css('#project .board', :count => project.boards.count)
  end

end
