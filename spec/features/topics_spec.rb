require 'spec_helper'

feature 'Topics', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'from an existing board' do
    given(:user) { User.first }
    given(:board) { Fabricate(:board, :user => user) }

    background do
      visit root_path(:anchor => '/boards/%d' % board.id)
    end

    scenario 'are shown' do
      expect(page).to have_css('.topic', :count => board.topics.count)
    end

    scenario 'can be created' do
      title = Faker::Lorem.sentence
      description =Faker::Lorem.sentence

      page.find('.add-topic').click
      expect(page).to have_css('.new-topic')

      within('.new-topic') do
        fill_in('topic-title', :with => title)
        fill_in('topic-description', :with => description)
      end

      page.find('.save-topic').click
      expect(page).to_not have_css('.save-topic')

      sleep(1)
      board.reload
      expect(page).to have_css('.topic', :count => board.topics.count)
    end

    scenario 'can be edited' do
      topic = board.topics.first
      title = Faker::Lorem.sentence
      description =Faker::Lorem.sentence

      page.find('.topic-%s' % topic.id).click()

      within('.topic') do
        fill_in('topic-title', :with => title)
        fill_in('topic-description', :with => description)
      end

      page.find('.save-topic').click

      expect(page).to_not have_css('.save-topic')
      sleep(1)
      topic.reload

      expect(topic.title).to eq(title)
      expect(topic.description).to eq(description)
    end

    scenario 'can be deleted' do
      topics_count = board.topics.count
      topic = board.topics.first

      page.find('.topic-%s' % topic.id).click()
      page.find('.remove-topic').click

      expect(page).to have_css('.topic', :count => topics_count - 1)
      expect(board.topics.reload.count).to eq(topics_count - 1)
    end
  end
end
