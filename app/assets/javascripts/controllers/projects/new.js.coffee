Doers.ProjectsNewController = Ember.Controller.extend
  save: ->
    @get('store').commit()
    @get('target.router').transitionTo('dashboard')
  cancel: ->
    @get('content').deleteRecord()
    @get('target.router').transitionTo('dashboard')
