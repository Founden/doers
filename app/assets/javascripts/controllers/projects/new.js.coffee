Doers.ProjectsNewController = Ember.Controller.extend
  save: (view)->
    if @get('content.title') and @get('content.website')
      @get('store').commit()
      @get('target.router').transitionTo('dashboard')
    else
      message = view.$().find('.on-error').text()
      @get('namespace').alert(message, 'alert')
  cancel: ->
    @get('content').deleteRecord()
    @get('target.router').transitionTo('dashboard')
