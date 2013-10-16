Ember.TextArea.reopen
  autoresize: true

  didInsertElement: ->
    @adjustHeight()

  valueChanged: ( ->
    @adjustHeight()
  ).observes('value')

  adjustHeight: ->
    if @get('autoresize')
      @$().height(0)
      @$().height(@get('element.scrollHeight'))
