Doers.Startup = DS.Model.extend
  externalId: DS.attr('number')
  title: null
  description: null
  website: null
  logoUrl: null
  isSelected: false

  slug: (->
    'startup-' + @get('externalId')
  ).property('externalId')
