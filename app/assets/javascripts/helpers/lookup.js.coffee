Ember.Handlebars.helper 'lookup', (component, options) ->
  Ember.Handlebars.helpers[component].call(@, options)
