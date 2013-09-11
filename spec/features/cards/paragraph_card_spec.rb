require 'spec_helper'

feature 'Paragraph', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards,
                :user => User.first, :card_types => %w(card/paragraph))
    end
    given(:board) { project.boards.first }
    given(:card) { board.cards.first }

    background do
      visit root_path(:anchor => '/boards/%d' % board.id)
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card-item', :count => 1)

      expect(page).to have_content(card.title)
      expect(page).to have_content(card.content)
    end

    context 'when clicked' do
      let(:title) { Faker::Lorem.sentence }
      let(:content) { Faker::Lorem.sentence }

      background do
        page.find('.card-%d' % card.id).click
      end

      scenario 'can edit card details in editing screen' do

        within('.card-edit') do
          fill_in('title', :with => title)
          fill_in('content', :with => content)
        end

        page.find('.save-card').click
        sleep(1)
        expect(page).to_not have_css('.card-edit')

        card.reload
        expect(card.title).to eq(title)
        expect(card.content).to eq(content)

        expect(page).to have_content(card.title)
        expect(page).to have_content(card.content)
      end
    end
  end
end
