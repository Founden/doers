require 'spec_helper'

feature 'Map', :js, :slow, :pending do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing topic' do
    given(:card) { Fabricate('card/map', :user => User.first) }
    given(:topic) { card.topic }

    background do
      visit root_path(:anchor => '/board/%d/topic/%d' % [card.board.id, card.topic.id])
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.card', :count => 1)
      expect(page.source).to include(card.title)
      expect(page.source).to match(/maps\.googleapis\.com/)
      expect(page.source).to include("#{card.longitude}")
      expect(page.source).to include("#{card.latitude}")
    end

    context 'when edited' do
      given(:title) { Faker::Lorem.sentence }
      given(:content) { Faker::Lorem.sentence }
      given(:locations) { MultiJson.load(
        Rails.root.join('spec/fixtures/openstreetmap_london.json')) }
      given(:place) { locations.first }

      background do
        proxy.stub(/nominatim/).and_return(
          :jsonp => locations, :callback_param => 'json_callback'
        )
      end

      scenario 'can be saved' do
        within('.card-edit') do
          fill_in('title', :with => title)
          fill_in('content', :with => content)
          fill_in('query', :with => place['display_name'])
        end
        sleep(1)
        page.find('.save-card').click

        sleep(1)
        card.reload
        expect(card.title).to eq(title)
        expect(card.content).to eq(content)
        expect(card.latitude).to eq(place['lat'])
        expect(card.longitude).to eq(place['lon'])

        expect(page.source).to include(card.latitude)
        expect(page.source).to include(card.longitude)
      end

    end
  end
end
