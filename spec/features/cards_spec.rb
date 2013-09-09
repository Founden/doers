require 'spec_helper'

feature 'Cards', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards_and_cards, :user => User.first)
    end
    given(:board) { project.boards.first }
    given(:card) { board.cards.first }

    background do
      visit root_path(:anchor => '/boards/%d' % board.id)
    end

    scenario 'are shown' do
      expect(page).to have_css('#board-%d' % board.id, :count => 1)

      cards_classname = '.cards .card-item' % board.id
      expect(page).to have_css(cards_classname, :count => board.cards.count)
    end

    context 'can not be repositioned' do
      background do
        # Update every card position
        board.cards.each do |card|
          card.update_attribute(:position, card.id)
        end
      end

      scenario 'when dragged and dropped' do
        pending
        order = board.cards.pluck('id', 'position').flatten

        target = page.first('.card-item')
        source = page.all('.card-item').last

        page.execute_script('$("#%s").trigger("dragstart")' % source['id'])
        page.execute_script('$("#%s").trigger("drop")' % target['id'])
        # TODO: Why this no work??!
        # source.drag_to(target)

        sleep(1)
        expect(order).to eq(
          board.cards.reload.pluck('id', 'position').flatten)
      end
    end
  end

end
