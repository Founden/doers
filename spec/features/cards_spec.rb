require 'spec_helper'

feature 'Cards', :js, :focus, :vcr => {:cassette_name=>:angel_list_oauth2} do
  background do
    sign_in_with_angel_list
  end

  scenario 'have title' do
    user    = User.first
    project = Fabricate(:project, :user => user)
    board   = Fabricate(:board, :user => user, :project => project)
    card    = Fabricate('card/phrase', :project => project, :board => board, :user => user)

    visit root_path(:anchor => 'projects/%d/boards/%d' % [project.id, board.id])

    expect(page).to have_content(card.title)
  end

  scenario 'inherit class name from type' do
    user    = User.first
    project = Fabricate(:project, :user => user)
    board   = Fabricate(:board, :user => user, :project => project)
    card    = Fabricate('card/phrase', :project => project, :board => board, :user => user)

    visit root_path(:anchor => 'projects/%d/boards/%d' % [project.id, board.id])

    expect(page).to have_css('#board .%s' % card.class.name.demodulize.downcase)
  end

end
