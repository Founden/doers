require 'spec_helper'

feature 'Number', :js, :slow, :vcr do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards,
                :user => User.first, :card_types => %w(card/number))
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
      expect(page).to have_content(card.content)
    end

    context 'when clicked on edit' do
      let(:card_attrs) { Fabricate.attributes_for('card/number') }

      background do
        page.find('.card-%d .card-settings' % card.id).click
        page.find('#dropdown-card-%d .toggle-editing' % card.id).click
      end

      scenario 'can edit card details in editing screen' do
        edit_css = '#edit-card-%d' % card.id

        within(edit_css) do
          fill_in('title', :with => card_attrs[:title])
          fill_in('content', :with => card_attrs[:content])
          fill_in('number', :with => card_attrs[:number])
        end
        page.find(edit_css + ' .actions .button').click

        expect(page).to_not have_css(edit_css)
        expect(page).to have_content(card_attrs[:title])
        expect(page).to have_content(card_attrs[:content])
        expect(page).to have_content(card_attrs[:number])
      end
    end

  end
end
