Ember.TextArea.reopen
  autoresize: true

  didInsertElement: ->
    @adjustHeight()

  valueChanged: ( ->
    @adjustHeight()
  ).observes('value')

  adjustHeight: ->
    if @get('autoresize')
      @$().height(@get('element.scrollHeight'))
