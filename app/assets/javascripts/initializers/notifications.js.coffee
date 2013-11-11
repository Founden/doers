Doers.initializer
  name: 'notifications'
  initialize: (container, application)->
    return unless window.WebSocket

    adapter = container.lookup('adapter:application')

    endpoint = 'ws://%@%@'.fmt(
      window.location.host, adapter.buildURL('notification'))

    # Register the container namespace
    socket = new WebSocket(endpoint)

    socket.onmessage = (event) ->
      if event.data.length
        data = $.parseJSON(event.data)
        alert = container.lookup('view:alert')
        alert.set('message', data.activity.slug)
        alert.appendTo(application.get('notificationsElement'))
