require 'spec_helper'

feature 'Interval', :js, :slow, :vcr do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards,
                :user => User.first, :card_types => %w(card/interval))
    end
    given(:board) { project.boards.first }
    given(:card) { board.cards.first }

    background do
      visit root_path(:anchor=>'projects/%d/boards/%d' % [project.id, board.id])
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card', :count => 1)

      card_classname = '.cards .%s' % card.class.name.demodulize.downcase
      expect(page).to have_css(card_classname)

      expect(page).to have_content(card.title)
      expect(page).to have_content('%g' % card.minimum)
      expect(page).to have_content('%g' % card.maximum)
      expect(page).to have_content('%g' % card.selected)
    end
  end

end
