require 'spec_helper'

feature 'Video', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards,
                :user => User.first, :card_types => %w(card/video))
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
      given(:videos) do
        MultiJson.load(Rails.root.join('spec/fixtures/youtube_yandex.json'))
      end
      given(:video) { videos['feed']['entry'].first }
      given(:image) do
        StringIO.new Rails.root.join('spec', 'fixtures', 'test.png').read
      end

      background do
        OpenURI.should_receive(:open_uri).and_return(image)
        proxy.stub(/gdata/).and_return(:jsonp => videos)
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
        expect(card.content).to eq(video['title']['$t'])
        expect(card.provider).to eq('youtube')
        expect(video['id']['$t']).to match(card.video_id)

        expect(page).to have_content(card.title)
        expect(page.source).to include(video['media$group']['media$thumbnail'][0]['url'])
      end
    end
  end

end
