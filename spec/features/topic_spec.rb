require 'spec_helper'

feature 'Topic', :js, :aslow do
  background do
    sign_in_with_angel_list
  end

  context 'from an existing project board' do
    given(:user) { User.first }
    given(:card) { Fabricate('card/paragraph', :user => user) }
    given(:topic) { card.topic }
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
      expect(page).to have_css('.card')
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
        page.find('.toggle-alignment').click
        expect(page).to have_css('.topic-status.aligned')
        sleep(1)
        topic.reload

        expect(topic.aligned_card).to_not be_blank
      end

      scenario 'progress changes if aligned' do
        expect(page.find('.board-progress-bar')[:style]).to include(': 0%')
        page.find('.toggle-alignment').click
        sleep(1)
        expect(page.find('.board-progress-bar')[:style]).to_not include(': 0%')
      end

      scenario 'user can endorse' do
        expect(page).to have_css('.card-endorse-item', :count => 0)
        page.find('.add-endorse').click
        expect(page).to have_css('.card-endorse-item', :count => 1)
        sleep(1)
        expect(card.endorses.reload.count).to eq(1)

        page.find('.remove-endorse').click
        expect(page).to have_css('.card-endorse-item', :count => 0)
        sleep(1)
        expect(card.endorses.reload.count).to eq(0)
      end

      scenario 'it can be deleted' do
        page.find('.delete-card').click
        expect(page).to_not have_css('.card')
        sleep(1)
        topic.reload
        expect(topic.cards.count).to eq(0)
      end
    end

  end

end
