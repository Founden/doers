Doers.DeleteButtonView = Ember.View.extend
  confirmMessage: null
  attributeBindings: ['title']
  click: (event) ->
    if confirm(@get('confirmMessage'))
      @get('controller').send('destroy')
