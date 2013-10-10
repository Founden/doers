# Ember.js App
# ~~~~~~~~~~~~

#= require moment

#= require handlebars
#= require ember
#= require ./ember-data-v1.0.0-beta3
#= require doers

#= require_self
#= require_tree ./initializers
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


