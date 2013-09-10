require 'spec_helper'

feature 'Timestamp', :js, :slow do
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
      visit root_path(:anchor => '/boards/%d' % board.id)
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card-item', :count => 1)

      expect(page).to have_content(card.title)
      expect(page).to have_content(card.content.to_date.strftime('%d %b %Y'))
      expect(page).to have_content(card.content.to_time.strftime('%H:%M'))
    end

    context 'when clicked' do
      given(:title) { Faker::Lorem.sentence }
      given(:datetime) { DateTime.tomorrow.at_end_of_day }
      given(:date) { datetime.to_s(:db).split(' ').first }
      given(:time) { datetime.to_s(:db).split(' ').last }

      background do
        page.find('.card-%d' % card.id).click
      end

      scenario 'can edit card details in editing screen' do

        within('.card-edit') do

          fill_in('title', :with => title)
          fill_in('date', :with => date)
          fill_in('time', :with => time)
        end

        page.find('.save-card').click
        sleep(1)
        expect(page).to_not have_css('.card-edit')

        card.reload
        expect(card.title).to eq(title)

        expect(DateTime.parse(card.content).to_s(:db)).to eq(datetime.to_s(:db))

        expect(page).to have_content(card.title)
        expect(page).to have_content(date)
        expect(page).to have_content(time)
      end
    end
  end

end
