require 'spec_helper'

feature 'List', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'card from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards,
                :user => User.first, :card_types => %w(card/list))
    end
    given(:board) { project.boards.first }
    given(:card) { board.cards.first }

    background do
      visit root_path(:anchor => 'boards/%d' % board.id)
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card', :count => 1)

      expect(page).to have_css('.card-%d' % card.id)

      expect(page).to have_content(card.title)
      expect(page).to have_content(card.content)
      card.items.each do |item|
        expect(page).to have_content(item['label'])
        if item['checked']
          expect(page.source).to include('checked')
        end
      end
    end

    context 'when clicked on edit' do
      given(:card_attrs) { Fabricate.attributes_for('card/list') }

      background do
        page.find('.card-%d .card-settings' % card.id).click
        page.find('#dropdown-card-%d .toggle-editing' % card.id).click
      end

      scenario 'can edit card details in editing screen' do
        edit_css = '#edit-card-%d' % card.id

        within(edit_css) do
          fill_in('title', :with => card_attrs[:title])
          fill_in('content', :with => card_attrs[:content])
        end
        page.find(edit_css + ' .actions .does-save').click

        expect(page).to_not have_css(edit_css)

        card.reload
        expect(card.title).to eq(card_attrs[:title])
        expect(card.content).to eq(card_attrs[:content])

        expect(page).to have_content(card.title)
        expect(page).to have_content(card.content)
      end

      scenario 'can update card items' do
        edit_css = '#edit-card-%d' % card.id
        edit_item = page.all(edit_css + ' li').first

        within(edit_item) do
          fill_in('label', :with => card_attrs['items'].first['label'])

          # Toggle checkbox value
          uncheck('checkbox') if card_attrs['items'].first['checked']
          check('checkbox') unless card_attrs['items'].first['checked']
        end
        page.find(edit_css + ' .actions .does-save').click

        expect(page).to_not have_css(edit_css)

        card.reload
        first_item = card.items.first
        expect(first_item['label']).to eq(card_attrs['items'].first['label'])
        expect(
          first_item['checked']).to_not eq(card_attrs['items'].first['checked'])

        expect(page).to have_content(first_item['label'])
        expect(page.source).to include('checked') if first_item['checked']
      end

      scenario 'can remove list items in editing screen' do
        initial_list_size = card.items.size
        first_item = card.items.first

        edit_css = '#edit-card-%d' % card.id
        edit_item = page.all(edit_css + ' li').first

        edit_item.find('a.removes-item').click
        page.find(edit_css + ' .actions .does-save').click

        expect(page).to_not have_css(edit_css)

        card.reload
        expect(card.items.size).to eq(initial_list_size - 1)
        expect(page).to_not have_content(first_item['label'])
      end

      scenario 'can add a new card item' do
        initial_list_size = card.items.size
        edit_css = '#edit-card-%d' % card.id

        page.find(edit_css + ' a.adds-item').click
        # Pick the before-last item
        edit_item = page.all(edit_css + ' li')[card.items.size]

        within(edit_item) do
          fill_in('label', :with => card_attrs['items'].first['label'])
        end
        page.find(edit_css + ' .actions .does-save').click

        expect(page).to_not have_css(edit_css)

        card.reload
        expect(card.items.size).to eq(initial_list_size + 1)
        expect(page).to have_content(card.items.first['label'])
      end
    end
  end

end
