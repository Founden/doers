require 'spec_helper'

feature 'Photo', :js, :slow, :vcr => {:cassette_name=>:angel_list_oauth2} do
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
      visit root_path(:anchor=>'projects/%d/boards/%d' % [project.id, board.id])
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card', :count => 1)

      card_classname = '.cards .%s' % card.class.name.demodulize.downcase
      expect(page).to have_css(card_classname)

      expect(page).to have_content(card.title)
      expect(page.source).to include(card.image.attachment.url)
    end

    scenario 'updates image when dropping an image' do
      file = Rails.root.join('spec/fixtures/test.png')
      card_name = 'card-%s-%d' % [card.class.name.demodulize.downcase, card.id]

      old_image_url = card.image.attachment.url.force_encoding('UTF-8')
      page.attach_file(card_name, file)

      # Let it ajax
      sleep(0.5)
      expect(page.source).to_not include(old_image_url)
      expect(page.source).to match('data:image/png;base64')
    end
  end

end
