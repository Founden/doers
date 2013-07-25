require 'spec_helper'

feature 'Boards', :js, :slow, :vcr => {:cassette_name=>:angel_list_oauth2} do
  background do
    sign_in_with_angel_list
  end

  context 'from an existing project' do
    given(:project) { Fabricate(:project_with_boards, :user => User.first) }

    background do
      visit root_path(:anchor => 'projects/%d' % project.id)
    end

    scenario 'are shown' do
      expect(page).to have_css('#project .board',:count => project.boards.count)
      pending('test what details are shown')
    end
  end
end
