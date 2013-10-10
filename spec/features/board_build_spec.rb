require 'spec_helper'

feature 'Board', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'building' do
    given(:board) { Fabricate(:board, :author => User.first) }

    background do
      visit root_path(:anchor => '/boards/%d/build' % board.id)
    end

    context 'topics' do

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

        within('.topic-%s' % topic.id) do
          fill_in('topic-title', :with => title)
          fill_in('topic-description', :with => description)
        end

        page.find('.topic-%s .save-topic' % topic.id).click

        expect(page).to_not have_css('.save-topic')
        sleep(1)

        topic.reload
        expect(topic.title).to eq(title)
        expect(topic.description).to eq(description)
      end

      scenario 'can be deleted' do
        topic = board.topics.first
        page.find('.topic-%s .remove-topic' % topic.id).click

        sleep(1)
        board.reload
        expect(page).to have_css('.topic', :count => board.topics.count)
      end
    end
  end
end
