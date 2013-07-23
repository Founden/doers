require 'spec_helper'

feature 'Cards', :js, :focus, :vcr => {:cassette_name=>:angel_list_oauth2} do
  background do
    sign_in_with_angel_list
  end

  scenario 'user can access an existing card' do
    project = Fabricate(:project_with_boards, :user => User.first)
    board   = project.boards.first

    visit root_path(:anchor => 'projects/%d/boards/%d' % [project.id, board.id])

    expect(page).to have_css('#board .card', :count => board.cards.count)
  end

  scenario 'inherit class name from type' do
    project = Fabricate(:project_with_boards, :user => User.first)
    board   = project.boards.first
    card    = board.cards.first

    visit root_path(:anchor => 'projects/%d/boards/%d' % [project.id, board.id])

    expect(page).to have_css('#board .%s' % card.class.name.demodulize.downcase)
  end

end
