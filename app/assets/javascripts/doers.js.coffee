# Ember.js App
# ~~~~~~~~~~~~
#= require handlebars
#= require ember
#= require ember-data
#= require doers

#= require_self
#= require ./adapter
#= require ./store
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./templates
#= require_tree ./routes
#= require ./router

window.Doers ||= Ember.Application.create
  app_name: 'DOERS by Geekcelerator'
  rootElement: '#doers-app'

window.Doers.initializer
  name: 'AjaxCSRFToken'
  initialize: (container, application)->
    $.ajaxPrefilter (options, originalOptions, xhr)->
      token = $('meta[name="csrf-token"]').attr('content')
      xhr.setRequestHeader('X-CSRF-Token', token)

