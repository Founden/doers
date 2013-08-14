require 'spec_helper'

feature 'Phrase', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards,
                :user => User.first, :card_types => %w(card/phrase))
    end
    given(:board) { project.boards.first }
    given(:card) { board.cards.first }

    background do
      visit root_path(:anchor => '/boards/%d' % board.id)
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card', :count => 1)

      expect(page).to have_css('.card-%d' % card.id)

      expect(page).to have_content(card.title)
      expect(page).to have_content(card.content)
    end

    context 'when clicked on edit' do
      given(:card_attrs) { Fabricate('card/phrase') }

      background do
        page.find('.card-%d .card-settings' % card.id).click
        page.find('#dropdown-card-%d .toggle-editing' % card.id).click
      end

      scenario 'can edit card details in editing screen' do
        edit_css = '#edit-card-%d' % card.id

        within(edit_css) do
          fill_in('title', :with => card_attrs[:title])
          fill_in('content', :with => card_attrs[:content])
        end
        page.find(edit_css + ' .actions .does-save').click

        expect(page).to_not have_css(edit_css)

        card.reload
        expect(card.title).to eq(card_attrs[:title])
        expect(card.content).to eq(card_attrs[:content])

        expect(page).to have_content(card.title)
        expect(page).to have_content(card.content)
      end
    end
  end

end
