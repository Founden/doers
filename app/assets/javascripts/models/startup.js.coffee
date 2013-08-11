Doers.StartupMixin = Ember.Mixin.create
  id: null
  title: null
  description: null
  website: null
  logoUrl: null
  isSelected: false

  slug: (->
    'startup-' + @get('id')
  ).property('id')

# Use a simple object to not poluate `store`
# and avoid errors on `store.commit()`
Doers.AngelListStartup = Ember.Object.extend(Doers.StartupMixin)

Doers.Startup = DS.Model.extend Doers.StartupMixin,
  externalId: DS.attr('number')
