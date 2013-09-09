Doers.ProjectsShowController = Ember.Controller.extend

  update: ->
    if @get('content.title')
      @get('content').save()

  destroy: ->
    @get('content').deleteRecord()
    @get('content.store').commit()
    @get('target.router').transitionTo('projects.index')

  createBranch: (board) ->
    project = @get('content')
    branch = @container.resolve('model:board').createRecord
      title: board.get('title')
      description: board.get('description')
      parentBoard: board
      project: project
    branch.save()

