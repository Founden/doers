require 'spec_helper'

feature 'Book', :js, :slow, :pending do
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
      visit root_path(:anchor => '/boards/%d' % board.id)
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card-item', :count => 1)

      expect(page).to have_content(card.title)
      expect(page).to have_content(card.book_title)
      expect(page).to have_content(card.book_authors)
      expect(page.source).to include(card.image.attachment.url)
    end

    context 'when clicked' do
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
        page.find('.card-%d' % card.id).click
      end

      scenario 'can edit card details in editing screen' do

        within('.card-edit') do
          fill_in('title', :with => title)
          fill_in('query', :with => title)
        end

        sleep(1)
        page.all('.card-edit-search-results li').first.click
        page.find('.save-card').click
        sleep(1)
        expect(page).to_not have_css('.card-edit')

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
