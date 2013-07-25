require 'spec_helper'

feature 'Book', :js, :vcr => {:cassette_name=>:angel_list_oauth2} do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards,
                :user => User.first, :card_types => %w(card/book))
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
      expect(page.source).to include(card.url)
      expect(page).to have_content(card.book_title)
      expect(page).to have_content(card.book_authors)
      expect(page.source).to include(card.image.attachment.url)
    end
  end

end
