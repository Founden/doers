require 'spec_helper'

feature 'Topic', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'from an existing project board' do
    given(:user) { User.first }
    given(:topic) { Fabricate(:topic_with_cards, :user => user) }
    given(:cards) { topic.cards }
    given(:board) { topic.board }
    given(:project) { topic.project }
    given(:content) { Faker::Lorem.sentence }

    background do
      visit root_path(:anchor => '/topic/%d' % topic.id)
    end

    scenario 'is shown' do
      expect(page).to have_css('.topic', :count => 1)
      expect(page).to have_field('topic-title', :with => topic.title)
      expect(page).to have_field(
        'topic-description', :with => topic.description)
    end

    scenario 'cards can be added' do
      page.find('.show-card-picker').click
      expect(page).to have_css('.card-picker')
      expect(page).to_not have_css('.show-card-picker')
      page.all('.card-picker li').first.click
      expect(page).to have_css('.card', :count => cards.count + 1)
      expect(page).to_not have_css('.card-picker')
    end

    scenario 'comments can be created' do
      within('.activity-comment-form') do
        fill_in 'comment', :with => content
      end
      page.find('.create-comment').click
      sleep(1)
      expect(page).to have_css('.activity-comment', :count => 1)
      expect(topic.comments.count).to eq(1)
    end

    context 'with a card' do

      scenario 'it can be marked as aligned' do
        card = cards.first
        page.find('.card-%d .toggle-alignment' % card.id).click
        expect(page).to have_css('.topic-status.aligned')
        sleep(1)
        topic.reload
        expect(topic.aligned_card).to_not be_blank
      end

      scenario 'progress changes if aligned' do
        card = cards.first
        expect(page.find('.board-progress-bar')[:style]).to include(': 0%')
        page.find('.card-%d .toggle-alignment' % card.id).click
        sleep(1)
        expect(page.find('.board-progress-bar')[:style]).to_not include(': 0%')
        topic.reload
      end

      scenario 'it can be deleted' do
        card = cards.first
        cards_count = cards.count
        page.find('.card-%d .delete-card' % card.id).click
        expect(page).to have_css('.card', :count => cards_count - 1)
        sleep(1)
        topic.reload
        expect(topic.cards.count).to eq(cards_count - 1)
      end

      scenario 'user can endorse' do
        card = cards.last
        context = '.card-%d' % card.id
        expect(page).to have_css(context + ' .card-endorse-item', :count => 0)
        page.find(context + ' .add-endorse').click
        sleep(1)
        expect(page).to have_css(context + ' .card-endorse-item', :count => 1)
        expect(card.endorses.reload.count).to eq(1)
        page.find(context + ' .remove-endorse').click
        sleep(1)
        expect(page).to have_css(context + ' .card-endorse-item', :count => 0)
        expect(card.endorses.reload.count).to eq(0)
      end
    end

  end

end
