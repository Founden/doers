require 'spec_helper'

feature 'Map', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards,
                :user => User.first, :card_types => %w(card/map))
    end
    given(:board) { project.boards.first }
    given(:card) { board.cards.first }

    background do
      visit root_path(:anchor => '/boards/%d' % board.id)
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card-item', :count => 1)

      expect(page).to have_content(card.title)
      expect(page.source).to match(/maps\.googleapis\.com/)
      expect(page.source).to include(card.longitude)
      expect(page.source).to include(card.latitude)
    end

    context 'when clicked' do
      given(:title) { Faker::Lorem.sentence }
      given(:locations) { MultiJson.load(
        Rails.root.join('spec/fixtures/openstreetmap_london.json')) }
      given(:place) { locations.first }

      background do
        proxy.stub(/nominatim/).and_return(
          :jsonp => locations, :callback_param => 'json_callback'
        )
        page.find('.card-%d' % card.id).click
      end

      scenario 'can edit card details in editing screen' do

        within('.card-edit') do
          fill_in('title', :with => title)
          fill_in('query', :with => title)
        end

        sleep(1)
        page.all('.card-edit-search-results li').first.click
        page.find('.save-card').click
        sleep(1)
        expect(page).to_not have_css('.card-edit')

        card.reload
        expect(card.title).to eq(title)
        expect(card.latitude).to eq(place['lat'])
        expect(card.longitude).to eq(place['lon'])

        expect(page).to have_content(card.title)
        expect(page.source).to include(card.latitude)
        expect(page.source).to include(card.longitude)
      end
    end
  end

end
