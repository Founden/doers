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
#= require ./auth

window.Doers ||= Ember.Application.create
  Route: Auth.Route.extend()
  app_name: 'DOERS by Geekcelerator'
  rootElement: '#doers-app'
  client_id: null
