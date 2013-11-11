Doers.initializer
  name: 'updates'
  initialize: (container, application)->
    return unless window.WebSocket

    adapter = container.lookup('adapter:application')

    endpoint = 'ws://%@%@'.fmt(
      window.location.host, adapter.buildURL('updates'))

    # Register the container namespace
    socket = new WebSocket(endpoint)

    socket.onmessage = (event) =>
      if event.data.length
        data = $.parseJSON(event.data)
        for key, value of data
          alert = container.lookup('view:alert')
          alert.set('message', value.slug)
          alert.appendTo(application.get('notificationsElement'))
