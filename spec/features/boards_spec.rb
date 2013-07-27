require 'spec_helper'

feature 'Boards', :js, :slow, :vcr do
  background do
    sign_in_with_angel_list
  end

  context 'from an existing project' do
    given(:user) { User.first }
    given!(:project) { Fabricate(:project_with_boards, :user => user) }
    given!(:public_board) {}

    background do
      visit root_path(:anchor => 'projects/%d' % project.id)
    end

    scenario 'are shown' do
      expect(page).to have_css(
        '#project .boards .board', :count => project.boards.count)
    end

    context 'when no boards are available' do
      given(:public_board) { Fabricate(:public_board) }
      given(:project) { Fabricate(:project, :user => user) }

      scenario 'some public boards are shown' do
        expect(page).to have_css('#project .public-boards .board', :count => 1)
        expect(page).to have_content(public_board.title)
      end

      context 'on click' do
        background do
          find('#board-%d a' % public_board.id).click
        end

        scenario 'creates a branch for currrent project' do
          expect(page).to have_content(public_board.title)
          sleep(1)
          expect(user.cards.count).to eq(public_board.cards.count)
        end
      end
    end
  end

end
