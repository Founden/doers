Doers.ProjectsNewController = Ember.Controller.extend
  save: (view)->
    if @get('content.title') and @get('content.website')
      @get('store').commit()
      @get('target.router').transitionTo('dashboard')
    else
      self = @
      view.$().find('label').map ->
        if message = $(@).data('error')
          self.get('namespace').alert(message, 'alert')

  cancel: ->
    @get('content').deleteRecord()
    @get('target.router').transitionTo('dashboard')
