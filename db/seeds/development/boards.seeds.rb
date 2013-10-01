user = User.find_by(:email => ENV['EMAIL'])

after 'development:projects' do
  # Initial boards
  persona = Fabricate(:persona_board, :status => Board::STATES.last)
  problem = Fabricate(:problem_board, :status => Board::STATES.last)
  solution = Fabricate(:solution_board, :status => Board::STATES.last)
  # My boards
  user.projects.limit(2).each do |project|
    Fabricate(:branched_board, :user => user, :project => project, :parent_board => persona)
    Fabricate(:branched_board, :user => user, :project => project, :parent_board => problem)
    Fabricate(:branched_board, :user => user, :project => project, :parent_board => solution)
  end
end
