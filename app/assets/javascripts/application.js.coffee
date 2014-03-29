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
          showSpinner: false
          ease: 'ease'
          speed: 500

    Navigation:
      flagName: 'Doers.Navigation.toggled'
      toggeled: null

      saveToggle: ->
        try
          if localStorage.getItem(@flagName)
            localStorage.removeItem(@flagName)
          else
            localStorage.setItem(@flagName, true)
        catch
          false

      toggle: (saveFlag = true) ->
        $('.nav').toggleClass('narrow')
        $('.content').toggleClass('wide')
        @saveToggle() if saveFlag

      setup: ->
        $('.nav-toggle').on 'click', => @toggle()

        try
          @toggeled = localStorage.getItem(@flagName)
        catch
          false

        @toggle(false) if @toggeled

    setup: ->
      @Notifications.setup()
      @Progress.setup()
      @Navigation.setup()

  Doers.setup()

) window, jQuery
