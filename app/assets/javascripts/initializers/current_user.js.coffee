Doers.initializer
  name: 'currentUser'
  initialize: (container, application)->
    # Wait until all the promises are resolved
    application.deferReadiness()

    container.resolve('model:user').find('mine').then (user) ->
      # Register the `user:current` namespace
      container.register(
        'user:current', user, {instantiate: false, singleton: true})
      # Inject the namespace into controllers and routes
      container.injection('route', 'currentUser', 'user:current')
      container.injection('controller', 'currentUser', 'user:current')

      mixpanel.identify(user.get('email'))
      mixpanel.people.set
        NAME: user.get('nicename')
        LAST_VISIT: new Date()

      # Continue the boot process
      application.advanceReadiness()
