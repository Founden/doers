user = User.find_by(:email => ENV['EMAIL'])

after 'development:projects' do
  # Initial boards
  user.projects.limit(2).each do |project|
    Fabricate(:board, :user => user, :project => project)
    Fabricate(:board, :user => user, :project => project)
    Fabricate(:board, :user => user, :project => project)
  end
end
