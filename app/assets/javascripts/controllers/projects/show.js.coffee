Doers.ProjectsShowController = Ember.Controller.extend

  update: ->
    if @get('content.title')
      @get('content').save()

  destroy: ->
    project = @get('content')
    project.one 'didDelete', =>
      @get('target.router').transitionTo('projects.index')
    project.deleteRecord()
    project.get('store').commit()

  createBranch: (board) ->
    project = @get('content')
    branch = @container.resolve('model:board').createRecord
      title: board.get('title')
      description: board.get('description')
      parentBoard: board
      project: project
    branch.save()
