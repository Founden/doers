Doers.ProjectsShowController = Ember.Controller.extend

  createBranch: (board) ->
    project = @get('content')
    branch = @container.resolve('model:board').createRecord
      title: board.get('title')
      description: board.get('description')
      parentBoard: board
      project: project
    branch.save()

