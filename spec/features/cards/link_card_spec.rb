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
      Oembedr.should_receive(:known_service?).at_least(1).times.and_return(true)
      Oembedr.should_receive(:fetch).at_least(1).times.and_return(response)
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

    context 'when clicked on edit' do
      given(:title) { Faker::Lorem.sentence }
      given(:link) { Faker::Internet.http_url }

      background do
        page.find('.card-%d .card-settings' % card.id).click
        page.find('#dropdown-card-%d .toggle-editing' % card.id).click
      end

      scenario 'can edit card details in editing screen' do
        edit_css = '#edit-card-%d' % card.id

        within(edit_css) do
          fill_in('title', :with => title)
          fill_in('url', :with => link)
        end

        sleep(1)
        page.find(edit_css + ' .actions .button').click

        expect(page).to_not have_css(edit_css)

        card.reload
        expect(card.title).to eq(title)

        expect(page).to have_content(embed['title'])
        expect(page.source).to include(embed['html'])
      end
    end
  end

end
