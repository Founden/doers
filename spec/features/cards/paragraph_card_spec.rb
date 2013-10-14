require 'spec_helper'

feature 'Paragraph', :js, :focus do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing topic' do
    given(:card) { Fabricate('card/paragraph', :user => User.first) }
    given(:topic) { card.topic }

    background do
      visit root_path(:anchor => '/board/%d/topic/%d' % [card.board.id, card.topic.id])
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.card', :count => 1)
      expect(page.source).to include(card.title)
    end

    context 'when edited' do
      given(:title) { Faker::Lorem.sentence }
      given(:content) { Faker::Lorem.sentence }

      scenario 'can be saved' do
        within('.card-edit') do
          fill_in('title', :with => title)
          fill_in('content', :with => content)
        end
        page.find('.save-card').click

        sleep(1)
        card.reload
        expect(card.title).to eq(title)
        expect(card.content).to eq(content)
      end

      scenario 'can be marked as aligned' do
        page.find('.toggle-alignment').click
        expect(page).to have_css('.topic-status.aligned')
        sleep(1)
        card.reload
        expect(card.aligned).to be_true
      end

      scenario 'can be deleted' do
        page.find('.delete-card').click
        expect(page).to_not have_css('.card')
        sleep(1)
        topic.reload
        expect(topic.cards.count).to eq(0)
      end
    end
  end
end
