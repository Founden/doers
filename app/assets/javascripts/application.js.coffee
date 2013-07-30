#= require jquery

#= require pickadate/picker
#= require pickadate/picker.date
#= require pickadate/picker.time

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

    setup: ->
      @Notifications.setup()

  Doers.setup()

) window, jQuery
