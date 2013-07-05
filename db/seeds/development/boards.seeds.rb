user = User.find_by(:email => ENV['EMAIL'])

after 'development:projects' do
  # Initial boards
  persona = Fabricate(:persona_board, :status => Board::STATES.last)
  problem = Fabricate(:problem_board, :status => Board::STATES.last)
  solution = Fabricate(:solution_board, :status => Board::STATES.last)
  # My boards
  user.projects.limit(2).each do |project|
    Fabricate(:branched_board, :user => user, :parent_board => persona,
              :project => project)
    Fabricate(:branched_board, :user => user, :parent_board => problem,
              :project => project)
    Fabricate(:branched_board, :user => user, :parent_board => solution,
              :project => project)
  end
  user.projects.limit(2).offset(2).each do |project|
    Fabricate(:branched_board, :user => user, :parent_board => persona,
              :project => project)
    Fabricate(:branched_board, :user => user, :parent_board => problem,
              :project => project)
  end
  user.projects.offset(4).each do |project|
    Fabricate(:branched_board, :user => user, :parent_board => persona,
              :project => project)
  end

  # Other project boards
  projects = Project.all - user.projects
  # - with persona board
  projects.sample(10).each do |project|
    Fabricate(:branched_board, :user => project.user, :parent_board => persona,
              :project => project)
  end
  # - with problem board
  projects.sample(5).each do |project|
    Fabricate(:branched_board, :user => project.user, :parent_board => problem,
              :project => project)
  end
  # - with solution board
  projects.sample(5).each do |project|
    Fabricate(:branched_board, :user => project.user, :parent_board => solution,
              :project => project)
  end
end
