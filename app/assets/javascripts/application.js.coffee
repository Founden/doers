#= require jquery
#= require nprogress
#= require nprogress-ajax

#= require_self

((w, $) ->
  Doers =
    Notifications:
      container: $('#notifications')

      setup: ->
        @container.find('.close').one 'click', @close

      close: (e) ->
        e.preventDefault()
        $(@).parents('.alert-box').remove()

    Progress:
      setup: ->
        NProgress.configure
          # showSpinner: false
          ease: 'ease'
          speed: 500
          # trickle: false

    setup: ->
      @Notifications.setup()
      @Progress.setup()

  Doers.setup()

) window, jQuery
