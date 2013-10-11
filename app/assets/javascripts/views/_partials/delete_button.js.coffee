Doers.DeleteButtonView = Ember.View.extend
  confirmMessage: null
  click: (event) ->
    if confirm(@get('confirmMessage'))
      @get('controller').send('destroy')
