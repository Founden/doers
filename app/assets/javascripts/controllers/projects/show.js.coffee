Doers.ProjectsShowController = Ember.Controller.extend

  isEditing: false

  edit: ->
    @toggleProperty('isEditing', true)

  createBranch: (board) ->
    project = @get('content')
    branch = @container.resolve('model:board').createRecord
      title: board.get('title')
      author: board.get('author')
      parentBoard: board
      project: project

  removeBranch: (board) ->
    @get('content.boards').removeObject(board)

