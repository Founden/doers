Doers.ProjectsNewController = Ember.Controller.extend
  save: ->
    if @get('content.title') and @get('content.website')
      @get('store').commit()
      @get('target.router').transitionTo('dashboard')
    else
      @get('namespace').alert(
        @get('namespace')._('Please give it a title and a website first.'),
        'alert'
      )
  cancel: ->
    @get('content').deleteRecord()
    @get('target.router').transitionTo('dashboard')
