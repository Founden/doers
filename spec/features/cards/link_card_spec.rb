require 'spec_helper'

feature 'Link', :js, :focus do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing topic' do
    given(:card) { Fabricate('card/photo', :user => User.first) }

    background do
      visit root_path(:anchor => '/board/%d/topic/%d' % [card.board.id, card.topic.id])
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.card', :count => 1)
      expect(page.soruce).to include(card.title)
      expect(page.source).to include(embed['title'])
    end

    context 'when edited' do
      given(:title) { Faker::Lorem.sentence }
      given(:url) { Faker::Internet.http_url }

      scenario 'can be saved' do
        within('.card-edit') do
          fill_in('title', :with => title)
          fill_in('url', :with => url)
        end
        page.find('.save-card').click

        sleep(1)
        card.reload
        expect(card.title).to eq(title)
        expect(page).to have_content(card.title)
        expect(page).to have_content(embed['title'])
      end
    end

  end
end
