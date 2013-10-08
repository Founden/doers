Doers.ControllerAlertMixin = Ember.Mixin.create

  alert: (message, type)->
    view = @container.lookup('view:alert')
    view.set('message', message)
    view.set('type', type)
    view.appendTo(@get('namespace.notificationsElement'))
    view
