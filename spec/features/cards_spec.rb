require 'spec_helper'

feature 'Cards', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards, :user => User.first)
    end
    given(:board) { project.boards.first }
    given(:card) { board.cards.first }

    background do
      visit root_path(:anchor=>'/boards/%d' % board.id)
    end

    scenario 'are shown' do
      expect(page).to have_css('#board-%d' % board.id, :count => 1)

      cards_classname = '#board-%d .cards .card' % board.id
      expect(page).to have_css( cards_classname, :count => board.cards.count)
    end
  end

end
