Doers.initializer
  name: 'AjaxCSRFToken'
  initialize: (container, application)->
    $.ajaxPrefilter (options, originalOptions, xhr)->
      token = $('meta[name="csrf-token"]').attr('content')
      xhr.setRequestHeader('X-CSRF-Token', token)
