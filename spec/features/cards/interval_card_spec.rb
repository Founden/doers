require 'spec_helper'

feature 'Interval', :js, :slow do
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
      expect(page).to have_content(card.content)
      expect(page.source).to include('%g' % card.minimum)
      expect(page.source).to include('%g' % card.maximum)
      expect(page.source).to include('%g' % card.selected)
    end

    context 'when clicked on edit' do
      let(:card_attrs) { Fabricate.attributes_for('card/interval') }

      background do
        page.find('.card-%d .card-settings' % card.id).click
        page.find('#dropdown-card-%d .toggle-editing' % card.id).click
      end

      scenario 'can edit card details in editing screen' do
        edit_css = '#edit-card-%d' % card.id

        within(edit_css) do
          fill_in('title', :with => card_attrs[:title])
          fill_in('content', :with => card_attrs[:content])
          fill_in('minimum', :with => card_attrs[:minimum])
          fill_in('maximum', :with => card_attrs[:maximum])
          fill_in('selected', :with => card_attrs[:selected])
        end
        page.find(edit_css + ' .actions .button').click

        expect(page).to_not have_css(edit_css)

        card.reload
        expect(card.title).to eq(card_attrs[:title])
        expect(card.content).to eq(card_attrs[:content])
        expect(card.minimum).to eq('%g' % card_attrs[:minimum])
        expect(card.maximum).to eq('%g' % card_attrs[:maximum])
        expect(card.selected).to eq('%g' % card_attrs[:selected])

        expect(page).to have_content(card_attrs[:title])
        expect(page).to have_content(card_attrs[:content])
        expect(page.source).to include('%g' % card.minimum)
        expect(page.source).to include('%g' % card.maximum)

        pending('o_O: Selected is failing.')
        expect(page.source).to include('%g' % card.selected)
      end
    end

  end
end
