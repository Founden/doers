Doers.initializer
  name: 'updates'
  initialize: (container, application)->
    return unless window.WebSocket

    adapter = container.lookup('adapter:application')
    store = container.lookup('store:main')

    endpoint = 'ws://%@%@'.fmt(
      window.location.host, adapter.buildURL('updates'))

    # Register the container namespace
    socket = new WebSocket(endpoint)
    socket.onmessage = (event) ->
      if event.data.length
        data = $.parseJSON(event.data)
        store.pushPayload('activity', data)

    # Handle page reloads properly
    if window.onbeforeunload == null
      window.onbeforeunload = socket.close
    else
      window.addEventListener('beforeunload', socket.close , true)
