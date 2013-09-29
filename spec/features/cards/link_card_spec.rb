require 'spec_helper'

feature 'Link', :js, :slow, :pending do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards,
                :user => User.first, :card_types => %w(card/link))
    end
    given(:board) { project.boards.first }
    given(:card) { board.cards.first }
    given(:embed) do
      { 'title' => Faker::Lorem.sentence }
    end
    given(:response) do
      Faraday::Response.new({ :body => embed })
    end

    background do
      Oembedr.should_receive(:known_service?).at_least(1).times.and_return(true)
      Oembedr.should_receive(:fetch).at_least(1).times.and_return(response)
      visit root_path(:anchor => '/boards/%d' % board.id)
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card-item', :count => 1)

      expect(page).to have_content(card.title)
      expect(page.source).to include(embed['title'])
    end

    context 'when clicked' do
      given(:title) { Faker::Lorem.sentence }
      given(:url) { Faker::Internet.http_url }

      background do
        page.find('.card-%d' % card.id).click
      end

      scenario 'can edit card details in editing screen' do

        within('.card-edit') do
          fill_in('title', :with => title)
          fill_in('url', :with => url)
        end

        page.find('.save-card').click
        sleep(1)
        expect(page).to_not have_css('.card-edit')

        card.reload
        expect(card.title).to eq(title)

        expect(page).to have_content(card.title)
        expect(page).to have_content(embed['title'])
      end
    end
  end

end
