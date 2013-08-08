Doers.ProjectItemController = Ember.ObjectController.extend
  requiresConfirmation: false

  confirm: ->
    @set('requiresConfirmation', true)

  cancel: ->
    @set('requiresConfirmation', false)

  remove: ->
    project = @get('content')
    project.deleteRecord()
    project.get('store').commit()
