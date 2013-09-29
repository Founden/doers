require 'spec_helper'

feature 'Photo', :js, :slow, :pending do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards,
                :user => User.first, :card_types => %w(card/photo))
    end
    given(:board) { project.boards.first }
    given(:card) { board.cards.first }

    background do
      visit root_path(:anchor => '/boards/%d' % board.id)
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card-item', :count => 1)

      expect(page).to have_content(card.title)
      expect(page.source).to include(card.image.attachment.url)
    end

    context 'when clicked' do
      given(:title) { Faker::Lorem.sentence }
      given(:image_path) { Rails.root.join('spec/fixtures/test.png') }

      background do
        page.find('.card-%d' % card.id).click
      end

      scenario 'can edit card details in editing screen' do
        old_image_url = card.image.attachment.url.force_encoding('UTF-8')

        within('.card-edit') do
          fill_in('title', :with => title)
          attach_file('image', image_path)
        end

        page.find('.save-card').click
        sleep(1)
        expect(page).to_not have_css('.card-edit')

        card.reload
        expect(card.title).to eq(title)

        expect(page).to have_content(card.title)
        expect(page.source).to_not include(old_image_url)
        expect(page.source).to match('data:image/png;base64')
      end
    end
  end
end
