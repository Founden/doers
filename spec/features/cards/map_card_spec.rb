require 'spec_helper'

feature 'Map', :js, :slow, :vcr do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards,
                :user => User.first, :card_types => %w(card/map))
    end
    given(:board) { project.boards.first }
    given(:card) { board.cards.first }

    background do
      visit root_path(:anchor=>'projects/%d/boards/%d' % [project.id, board.id])
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card', :count => 1)

      expect(page).to have_css('.card-%d' % card.id)

      expect(page).to have_content(card.title)
      expect(page).to have_content(card.content)
      expect(page.source).to match(/maps\.googleapis\.com/)
      expect(page.source).to include(card.longitude)
      expect(page.source).to include(card.latitude)
    end
  end

end
