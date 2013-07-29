Doers.BoardsShowController = Ember.ObjectController.extend Doers.ControllerAlertMixin,
  saveCard: ->
    @get('content').save().then =>
      @set('isEditing', false)
