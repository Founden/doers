require 'spec_helper'

feature 'Photo', :js, :focus do
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
      expect(page.source).to include(card.content)
      expect(page.source).to include(card.image.attachment.url)
    end

    context 'when edited' do
      given(:title) { Faker::Lorem.sentence }
      given(:image_path) { Rails.root.join('spec/fixtures/test.png') }

      scenario 'can be saved' do
        old_image_url = card.image.attachment.url.force_encoding('UTF-8')

        within('.card-edit') do
          fill_in('title', :with => title)
          attach_file('image', image_path)
        end
        page.find('.save-card').click

        sleep(1)
        card.reload
        expect(card.title).to eq(title)

        expect(page.source).to_not include(old_image_url)
        expect(page.source).to match('data:image/png;base64')
      end
    end

  end
end
