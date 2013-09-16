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
      visit root_path(:anchor => '/boards/%d' % board.id)
    end

    scenario 'is shown with details' do
      expect(page).to have_css('.cards .card-item', :count => 1)

      expect(page).to have_css('.card-%d' % card.id)

      expect(page).to have_content(card.title)
      expect(page).to have_content(card.content)
      card.items.each do |item|
        expect(page).to have_content(item['label'])
        if item['checked']
          expect(page.source).to include('icon-checkmark')
        end
      end
    end

    context 'when clicked' do
      given(:card_attrs) { Fabricate.attributes_for('card/list') }

      background do
        page.find('.card-%d' % card.id).click
      end

      scenario 'can edit card details in editing screen' do

        within('.card-edit') do
          fill_in('title', :with => card_attrs[:title])
          fill_in('content', :with => card_attrs[:content])
        end
        page.find('.save-card').click
        sleep(1)
        expect(page).to_not have_css('.card-edit')

        card.reload
        expect(card.title).to eq(card_attrs[:title])
        expect(card.content).to eq(card_attrs[:content])

        expect(page).to have_content(card.title)
        expect(page).to have_content(card.content)
      end

      scenario 'can update card items' do
        label = Faker::Lorem.sentence
        item = card.items.first
        checked = item['checked']

        edit_item = page.all('.card-edit-check-item').first
        checkbox = edit_item.all('.card-edit-check-box').first
        within(edit_item) do
          fill_in('label', :with => label)
          # Toggle checkbox value
          checkbox.click
        end
        page.find('.save-card').click
        sleep(1)

        expect(page).to_not have_css('card-edit')
        expect(page).to have_content(label)
        # Should be toggled
        if !checked
          expect(page).to have_css('.card-item-check-list .icon-checkmark')
        end

        card.reload
        entry = card.items.first
        expect(entry['label']).to eq(label)
        expect(entry['checked']).to_not eq(checked)
      end

      scenario 'can remove list items in editing screen' do
        initial_list_size = card.items.size
        first_item = card.items.first

        edit_item = page.all('.card-edit-check-item').first

        edit_item.find('.remove-check-list-item').click
        page.find('.save-card').click
        sleep(1)
        expect(page).to_not have_css('card-edit')

        card.reload
        expect(card.items.size).to eq(initial_list_size - 1)
        expect(page).to_not have_content(first_item['label'])
      end

      scenario 'can add a new card item' do
        initial_list_size = card.items.size

        page.find('.add-check-list-item').click
        # Pick the before-last item
        edit_item = page.all('.card-edit-check-item')[card.items.size]

        within(edit_item) do
          fill_in('label', :with => card_attrs['items'].first['label'])
        end
        page.find('.save-card').click
        sleep(1)
        expect(page).to_not have_css('card-edit')

        card.reload
        expect(card.items.size).to eq(initial_list_size + 1)
        expect(page).to have_content(card.items.first['label'])
      end
    end
  end

end
