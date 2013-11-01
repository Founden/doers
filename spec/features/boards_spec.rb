require 'spec_helper'

feature 'Boards', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'from an existing project' do
    given(:user) { User.first }
    given(:project) { Fabricate(:project_with_boards, :user => user) }

    background do
      visit root_path(:anchor => '/projects/%d' % project.id)
    end

    scenario 'are shown' do
      expect(page).to have_css(
        '.board-list .board-item', :count => project.boards.count)
    end
  end

  context 'screen' do
    given(:user) { User.first }
    given(:project) { Fabricate(:project_with_boards, :user => user) }
    given(:board) { project.boards.first }

    background do
      visit root_path(:anchor => '/boards/%d' % board.id)
    end

    scenario 'confirms deletion and removes board' do
      boards_count = project.boards.count

      find('.remove-board').click

      expect(page).to have_css(
        '.board-list .board-item', :count => boards_count - 1)
      expect(project.boards.count).to eq(boards_count - 1)
    end
  end

  context 'creation screen' do
    given(:user) { User.first }
    given(:project) { Fabricate(:project, :user => user) }
    given(:attrs) { Fabricate.to_params(:board) }

    background do
      visit root_path(:anchor => '/projects/%d/add-board' % project.id)
    end

    scenario 'with a title and description set, creates a new board' do
      within('.board') do
        fill_in :title, :with => attrs[:title]
        fill_in :description, :with => attrs[:description]
      end

      click_on('create-board')

      sleep(1)
      expect(page).to have_css('#board-%d' % user.boards.first.id)
      expect(page).to have_field(:title, :with =>  attrs[:title])
      expect(page).to have_field(:description, :with => attrs[:description])
    end

    scenario 'with missing title wont show create button' do
      within('.board') do
        fill_in :title, :with => ''
        fill_in :description, :with => attrs[:description]
      end
      expect(page).to_not have_css('#create-board')
    end
  end
end
