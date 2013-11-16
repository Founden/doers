Ember.TextArea.reopen
  attributeBindings: ['tabindex']
  tabindex: false
  autoresize: true

  didInsertElement: ->
    @adjustHeight()

  valueChanged: ( ->
    @adjustHeight()
  ).observes('value')

  adjustHeight: ->
    if @get('autoresize')
      @$().height(0) # Set this or it won't resize on line removals
      @$().height(@get('element.scrollHeight'))
