# Ember.js App
# ~~~~~~~~~~~~

#= require moment

#= require handlebars
#= require ember
#= require ember-data
#= require doers

#= require_self
#= require ./serializer
#= require ./adapter
#= require ./store
#= require_tree ./mixins
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes
#= require ./router


# Disable Ember.js version logging
Ember.LOG_VERSION = false

window.Doers ||= Ember.Application.create
  rootElement: '#doers-app'
  notificationsElement: '#notifications'
  errorDataAttr: 'error'

window.Doers.initializer
  name: 'AjaxCSRFToken'
  initialize: (container, application)->
    $.ajaxPrefilter (options, originalOptions, xhr)->
      token = $('meta[name="csrf-token"]').attr('content')
      xhr.setRequestHeader('X-CSRF-Token', token)
