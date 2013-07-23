Doers.ControllerAlertMixin = Ember.Mixin.create
  alertFromView: (view) ->
    self = @
    view.$().find('label').map ->
      if message = $(@).data('error')
        self.alert(message, 'alert')

  alert: (message, type)->
    view = @container.lookup('view:alert')
    view.set('message', message)
    view.set('type', type)
    view.appendTo(@get('namespace.notificationsElement'))
    view
