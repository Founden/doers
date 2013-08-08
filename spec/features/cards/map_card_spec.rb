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
      visit root_path(:anchor=>'boards/%d' % board.id)
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card', :count => 1)

      expect(page).to have_css('.card-%d' % card.id)

      expect(page).to have_content(card.title)
      expect(page).to have_content(card.content)
      expect(page.source).to match(/maps\.googleapis\.com/)
      expect(page.source).to include(card.longitude)
      expect(page.source).to include(card.latitude)
    end

    context 'when clicked on edit' do
      given(:title) { Faker::Lorem.sentence }
      given(:locations) { MultiJson.load(
        Rails.root.join('spec/fixtures/openstreetmap_london.json')) }
      given(:place) { locations.first }
      given(:place_title) { Faker::Address.country }

      background do
        proxy.stub(/nominatim/).and_return(
          :jsonp => locations, :callback_param => 'json_callback'
        )
        page.find('.card-%d .card-settings' % card.id).click
        page.find('#dropdown-card-%d .toggle-editing' % card.id).click
      end

      scenario 'can edit card details in editing screen' do
        edit_css = '#edit-card-%d' % card.id

        within(edit_css) do
          fill_in('title', :with => title)
          fill_in('place-name', :with => place_title)
        end

        page.find(edit_css + ' .map-search li').click
        page.find(edit_css + ' .actions .does-save').click

        expect(page).to_not have_css(edit_css)

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
