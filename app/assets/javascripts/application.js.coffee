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

    Mixpanel:
      setup: ->
        # TODO, track pageviews on Ember routes
        mixpanel.track_pageview()
        mixpanel.track_links('#signin-btn', 'LOGIN', {TYPE: 'AngelList'})
        mixpanel.track_links('#signout-btn', 'LOGOUT')
        mixpanel.track_links('#export-btn', 'EXPORT')

    setup: ->
      @Notifications.setup()
      @Progress.setup()
      @Navigation.setup()
      @Mixpanel.setup()

  Doers.setup()

) window, jQuery
