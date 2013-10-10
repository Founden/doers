Doers.AlertView = Ember.View.extend
  templateName: 'partials/alert'
  classNames: ['alert']
  classNameBindings: ['type']
  message: null
  type: null
  closeIcon: Ember.View.extend
    classNames: ['icon', 'icon-close']
    didInsertElement: ->
      @$().one 'click', =>
        @get('parentView').destroy()
