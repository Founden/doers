require 'spec_helper'

feature 'Link', :js, :slow, :vcr do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards,
                :user => User.first, :card_types => %w(card/link))
    end
    given(:board) { project.boards.first }
    given(:card) { board.cards.first }
    given(:embed) do
      { 'title' => Faker::Lorem.sentence, 'html' => Faker::Lorem.sentence }
    end
    given(:response) do
      Faraday::Response.new({ :body => embed })
    end

    background do
      Oembedr.should_receive(:known_service?).and_return(true)
      Oembedr.should_receive(:fetch).and_return(response)
      visit root_path(:anchor=>'projects/%d/boards/%d' % [project.id, board.id])
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card', :count => 1)

      card_classname = '.card-%d' % card.id
      expect(page).to have_css(card_classname)

      expect(page).to have_content(card.title)
      expect(page.source).to include(embed['title'])
      expect(page.source).to include(embed['html'])
    end
  end

end
