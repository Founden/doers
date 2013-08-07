Doers.ProjectsNewController = Ember.Controller.extend Doers.ControllerAlertMixin,
  save: (view)->
    if @get('content.title') and @get('content.website')
      @get('store').commit()
      @get('target.router').transitionTo('projects.index')
    else
      @alertFromView(view)

  cancel: ->
    @get('content').deleteRecord()
    @get('target.router').transitionTo('projects.index')
