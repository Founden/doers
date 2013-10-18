require 'spec_helper'

feature 'Photo', :js, :slow, :pending do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing topic' do
    given(:card) { Fabricate('card/photo', :user => User.first) }
    given(:topic) { card.topic }

    background do
      visit root_path(:anchor => '/board/%d/topic/%d' % [card.board.id, card.topic.id])
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.card', :count => 1)
      expect(page.source).to include(card.title)
      expect(page.source).to include(
        card.image.attachment.url.force_encoding('UTF-8'))
    end

    context 'when edited' do
      given(:title) { Faker::Lorem.sentence }
      given(:content) { Faker::Lorem.sentence }
      given(:image_path) { Rails.root.join('spec/fixtures/test.png') }

      scenario 'can be saved' do
        old_image_url = card.image.attachment.url.force_encoding('UTF-8')

        within('.card-edit') do
          fill_in('title', :with => title)
          fill_in('content', :with => content)
          attach_file('image', image_path)
        end
        sleep(1)
        page.find('.save-card').click

        sleep(1)
        card.reload
        expect(card.title).to eq(title)
        expect(card.content).to eq(content)

        expect(page.source).to_not include(old_image_url)
        expect(page.source).to include(
          card.image.attachment.url.force_encoding('UTF-8'))
      end
    end
  end
end
