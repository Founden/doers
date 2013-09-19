require 'spec_helper'

feature 'Board', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'building' do
    given(:board) do
      Fabricate(:persona_board, :user => User.first)
    end

    background do
      visit root_path(:anchor => '/boards/%d/build' % board.id)
    end

    scenario 'allows cards deletion' do
      cards_count = board.cards.count

      page.first('.card-item').click
      expect(page).to have_css('.card-edit')

      page.find('.card-edit-actions .button.remove-card').click
      expect(page).to_not have_css('.card-edit')
      expect(page).to have_css('.card-item', :count => cards_count - 1)
      expect(board.reload.cards.count).to eq(cards_count - 1)
    end

    context 'UI allows cards to be repositioned' do
      background do
        # Update every card position
        board.cards.each do |card|
          card.update_attribute(:position, card.id)
        end
      end

      scenario 'when dragged and dropped' do
        order = board.cards.pluck('id', 'position').flatten

        target = page.first('.card-item')
        source = page.all('.card-item').last

        page.execute_script('$("#%s").trigger("dragstart")' % source['id'])
        page.execute_script('$("#%s").trigger("drop")' % target['id'])
        # TODO: Why this no work??!
        # source.drag_to(target)

        sleep(1)
        expect(order).to_not eq(
          board.cards.reload.pluck('id', 'position').flatten)
      end
    end
  end
end
