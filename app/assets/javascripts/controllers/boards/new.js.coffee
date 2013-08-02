Doers.BoardsNewController = Ember.Controller.extend Doers.ControllerAlertMixin,
  save: (view)->
    if @get('content.title')
      @get('content').save().then =>
        @get('target.router').transitionTo('boards.show', @get('content'))
    else
      @alertFromView(view)

  cancel: ->
    @get('content').deleteRecord()
    @get('target.router').transitionTo('dashboard')
