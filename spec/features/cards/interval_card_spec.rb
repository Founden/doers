require 'spec_helper'

feature 'Interval', :js, :slow, :pending do
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
      visit root_path(:anchor => '/boards/%d' % board.id)
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card-item', :count => 1)

      expect(page).to have_content(card.title)
      expect(page.source).to include('%g' % card.minimum)
      expect(page.source).to include('%g' % card.maximum)
      expect(page.source).to include('%g' % card.selected)
    end

    context 'when clicked' do
      let(:card_attrs) { Fabricate.attributes_for('card/interval') }

      background do
        page.find('.card-%d' % card.id).click
      end

      scenario 'can edit card details in editing screen' do

        within('.card-edit') do
          fill_in('title', :with => card_attrs[:title])
          fill_in('minimum', :with => card_attrs[:minimum])
          fill_in('maximum', :with => card_attrs[:maximum])
          fill_in('selected', :with => card_attrs[:selected])
        end

        page.find('.save-card').click
        sleep(1)
        expect(page).to_not have_css('.card-edit')

        card.reload
        expect(card.title).to eq(card_attrs[:title])

        expect(card.minimum).to eq('%g' % card_attrs[:minimum])
        expect(card.maximum).to eq('%g' % card_attrs[:maximum])
        expect(card.selected).to eq('%g' % card_attrs[:selected])

        expect(page).to have_content(card_attrs[:title])
        expect(page).to have_content(card_attrs[:minimum])
        expect(page).to have_content(card_attrs[:maximum])
        expect(page).to have_content(card_attrs[:selected])
      end
    end

  end
end
