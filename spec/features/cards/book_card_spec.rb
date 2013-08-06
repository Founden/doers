require 'spec_helper'

feature 'Book', :js, :slow, :vcr do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards,
                :user => User.first, :card_types => %w(card/book))
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
      expect(page.source).to include(card.url)
      expect(page).to have_content(card.book_title)
      expect(page).to have_content(card.book_authors)
      expect(page.source).to include(card.image.attachment.url)
    end

    context 'when clicked on edit' do
      given(:title) { Faker::Lorem.sentence }
      given(:books) do
        MultiJson.load(Rails.root.join('spec/fixtures/google_books.json'))
      end
      given(:book) { books['items'].first }
      given(:image) do
        StringIO.new Rails.root.join('spec', 'fixtures', 'test.png').read
      end

      background do
        OpenURI.should_receive(:open_uri).and_return(image)
        proxy.stub(/volumes/).and_return(:jsonp => books)
        page.find('.card-%d .card-settings' % card.id).click
        page.find('#dropdown-card-%d .toggle-editing' % card.id).click
      end

      scenario 'can edit card details in editing screen' do
        edit_css = '#edit-card-%d' % card.id

        within(edit_css) do
          fill_in('title', :with => title)
          fill_in('book-title', :with => title)
        end

        sleep(1)
        page.all(edit_css + ' .book-search li').first.click
        page.find(edit_css + ' .actions .button').click

        expect(page).to_not have_css(edit_css)

        card.reload
        expect(card.title).to eq(title)
        expect(card.book_title).to eq(book['volumeInfo']['title'])
        expect(card.book_authors).to eq(
          book['volumeInfo']['authors'].join(', '))
        expect(card.url).to eq(book['volumeInfo']['infoLink'])

        expect(page).to have_content(card.title)
        expect(page).to have_content(card.book_title)
        expect(page).to have_content(card.book_authors)
      end
    end
  end

end
