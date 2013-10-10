require 'spec_helper'

feature 'Link', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing topic' do
    given(:card) { Fabricate('card/link', :user => User.first) }
    given(:topic) { card.topic }
    given(:embed) do
      { 'title' => Faker::Lorem.sentence }
    end
    given(:response) do
      Faraday::Response.new({ :body => embed })
    end

    background do
      Oembedr.should_receive(:known_service?).at_least(1).times.and_return(true)
      Oembedr.should_receive(:fetch).at_least(1).times.and_return(response)
      visit root_path(:anchor => '/board/%d/topic/%d' % [card.board.id, card.topic.id])
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.card', :count => 1)
      expect(page.source).to include(card.title)
      expect(page).to have_content(embed['title'])
    end

    context 'when edited' do
      given(:title) { Faker::Lorem.sentence }
      given(:url) { Faker::Internet.http_url }

      scenario 'can be saved' do
        within('.card-edit') do
          fill_in('title', :with => title)
          fill_in('url', :with => url)
        end
        sleep(1)
        page.find('.save-card').click

        sleep(1)
        card.reload
        expect(card.title).to eq(title)

        expect(page).to have_content(embed['title'])
      end

      scenario 'can be deleted', :pending do
        page.find('.delete-card').click
        expect(page).to_not have_css('.card')
        sleep(1)
        topic.reload
        expect(topic.cards.count).to eq(0)
      end
    end

  end
end
