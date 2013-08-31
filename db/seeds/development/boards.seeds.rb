user = User.find_by(:email => ENV['EMAIL'])

after 'development:projects' do
  # Initial boards
  persona = Fabricate(:persona_board, :status => Board::STATES.last)
  problem = Fabricate(:problem_board, :status => Board::STATES.last)
  solution = Fabricate(:solution_board, :status => Board::STATES.last)
  # My boards
  user.projects.limit(2).each do |project|
    persona.branch_for(user, project, {:title => persona.title} )
    problem.branch_for(user, project, {:title => problem.title} )
    solution.branch_for(user, project, {:title => solution.title} )
  end
  user.projects.limit(2).offset(2).each do |project|
  end
  user.projects.offset(4).each do |project|
    persona.branch_for(user, project, {:title => persona.title} )
    problem.branch_for(user, project, {:title => problem.title} )
  end

  # Other project boards
  projects = Project.all - user.projects
  # - with persona board
  projects.sample(10).each do |project|
    persona.branch_for(project.user, project, {:title => persona.title } )
  end
  # - with problem board
  projects.sample(5).each do |project|
    problem.branch_for(project.user, project, {:title => problem.title} )
  end
  # - with solution board
  projects.sample(5).each do |project|
    solution.branch_for(project.user, project, {:title => solution.title} )
  end
end
