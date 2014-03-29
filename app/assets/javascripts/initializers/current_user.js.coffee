Doers.initializer
  name: 'currentUser'
  initialize: (container, application)->
    # Wait until all the promises are resolved
    application.deferReadiness()

    container.lookup('store:main').find('user', 'mine').then (user) ->
      # Register the `user:current` namespace
      container.register(
        'user:current', user, {instantiate: false, singleton: true})
      # Inject the namespace into controllers and routes
      container.injection('route', 'currentUser', 'user:current')
      container.injection('controller', 'currentUser', 'user:current')

      # Continue the boot process
      application.advanceReadiness()
