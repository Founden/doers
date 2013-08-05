require 'spec_helper'

feature 'Timestamp', :js, :slow, :vcr do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards,
                :user => User.first, :card_types => %w(card/timestamp))
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
      expect(page.source).to include(card.content)
    end

    context 'when clicked on edit' do
      let(:title) { Faker::Lorem.sentence }
      let(:datetime) { DateTime.tomorrow.at_end_of_day }
      let(:date) { datetime.to_s(:db).split(' ').first }
      let(:time) { datetime.to_s(:db).split(' ').last }

      background do
        page.find('.card-%d .card-settings' % card.id).click
        page.find('#dropdown-card-%d .toggle-editing' % card.id).click
      end

      scenario 'can edit card details in editing screen' do
        edit_css = '#edit-card-%d' % card.id

        within(edit_css) do
          fill_in('title', :with => title)
          fill_in('date', :with => date)
          fill_in('time', :with => time)
        end
        page.find(edit_css + ' .actions .button').click

        expect(page).to_not have_css(edit_css)

        card.reload
        expect(card.title).to eq(title)
        expect(DateTime.parse(card.content).to_s(:db)).to eq(datetime.to_s(:db))

        expect(page).to have_content(title)
        expect(page.source).to include(datetime.to_s(:db))
      end
    end
  end

end
