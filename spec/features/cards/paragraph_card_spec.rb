require 'spec_helper'

feature 'Paragraph', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing topic' do
    given(:card) { Fabricate('card/paragraph', :user => User.first) }
    given(:topic) { card.topic }

    background do
      visit root_path(:anchor => '/board/%d/topic/%d' % [
        card.board.id, card.topic.id])
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.card', :count => 1)
      expect(page.find('.card-field-title').value).to eq(card.title)
      expect(page.find('.card-field-description').value).to eq(card.content)
    end

    context 'when edited' do
      given(:title) { Faker::Lorem.sentence }
      given(:content) { Faker::Lorem.sentence }

      background do
        page.find('.edit-card').click
      end

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

    end
  end
end
