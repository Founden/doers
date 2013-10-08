#= require jquery
#= require nprogress
#= require nprogress-ajax

#= require_self

((w, $) ->
  Doers =
    Notifications:
      container: $('#notifications')

      setup: ->
        @container.find('.icon-close').one 'click', @close

      close: (e) ->
        e.preventDefault()
        $(@).parents('.alert').remove()

    Progress:
      setup: ->
        NProgress.configure
          # showSpinner: false
          ease: 'ease'
          speed: 500
          # trickle: false

    Navigation:
      setup: ->
        $('.nav-toggle').on 'click', @toggle

      toggle: (e) ->
        $('.nav').toggleClass('narrow')
        $('.content').toggleClass('wide')

    setup: ->
      @Notifications.setup()
      @Progress.setup()
      @Navigation.setup()

  Doers.setup()

) window, jQuery
