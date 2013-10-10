require 'spec_helper'

feature 'Topic', :js, :slow do
  background do
    sign_in_with_angel_list
  end

  context 'from an existing project board' do
    given(:project) do
      Fabricate(:project_with_boards, :user => User.first)
    end
    given(:board) { project.boards.first }
    given(:topic) { board.parent_board.topics.first }
    given(:content) { Faker::Lorem.sentence }

    background do
      visit root_path(:anchor => '/board/%d/topic/%d' % [board.id, topic.id])
    end

    scenario 'is shown' do
      expect(page).to have_css('.topic', :count => 1)
      expect(page).to have_content(topic.title)
      expect(page).to have_content(topic.description)
    end

    scenario 'cards can be added' do
      page.find('.show-card-picker').click
      expect(page).to have_css('.card-picker')
      expect(page).to_not have_css('.show-card-picker')
      page.all('.card-picker li').first.click
      expect(page).to have_css('.card')
      expect(page).to_not have_css('.card-picker')
    end

    scenario 'comments can be created' do
      within('.activity-comment-form') do
        fill_in 'comment', :with => content
      end
      page.find('.create-comment').click
      expect(page).to have_css('.activity', :count => 1)
      expect(topic.comments.count).to eq(1)
    end
  end

end
