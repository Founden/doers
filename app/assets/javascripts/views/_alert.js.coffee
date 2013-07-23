Doers.AlertView = Ember.View.extend
  templateName: 'shared/alert'
  classNames: ['alert-box']
  classNameBindings: ['type']
  type: null
  message: null
  closeIcon: Ember.View.extend
    tagName: 'a'
    classNames: ['close']
    # Garbage-collect itself, since click event doesn't work for some reason
    # FIXME: WTF click is not triggered?!
    didInsertElement: ->
      self = @get('parentView')
      @$().one 'click', ->
        self.destroy()
