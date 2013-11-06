require 'spec_helper'

feature 'Number', :js, :slow, :pending do
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
      visit root_path(:anchor => '/boards/%d' % board.id)
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card-item', :count => 1)

      expect(page).to have_content(card.title)
      expect(page).to have_content(card.number)
      expect(page).to have_content(card.content.upcase)
    end

    context 'when clicked' do
      let(:card_attrs) { Fabricate.attributes_for('card/number') }

      background do
        page.find('.card-%d' % card.id).click
      end

      scenario 'can edit card details in editing screen' do

        within('.card-edit') do
          fill_in('title', :with => card_attrs[:title])
          fill_in('number', :with => card_attrs[:number])
          fill_in('content', :with => card_attrs[:content])
        end

        page.find('.save-card').click
        sleep(1)
        expect(page).to_not have_css('.card-edit')

        card.reload
        expect(card.title).to eq(card_attrs[:title])
        expect(card.content).to eq(card_attrs[:content])
        expect(card.number).to eq(card_attrs[:number].to_s)

        expect(page).to have_content(card.title)
        expect(page).to have_content(card.number)
        expect(page).to have_content(card.content.upcase)
      end
    end
  end

end
