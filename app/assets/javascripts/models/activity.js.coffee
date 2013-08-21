Doers.Activity = DS.Model.extend
  slug: DS.attr('string', readOnly: true)
  lastUpdate: DS.attr('string', readOnly: true)

  user: DS.belongsTo('Doers.User', readOnly: true, inverse: 'activities')
  project: DS.belongsTo('Doers.User', readOnly: true, inverse: 'activities')
  board: DS.belongsTo('Doers.User', readOnly: true, inverse: 'activities')
  # This one can go pretty crazy since it can represent:
  #   user, card, asset or other objects
  #   so we better load it when we really need it
  trackableId: DS.attr('number', readOnly: true)
  trackableType: DS.attr('string', readOnly: true)

  identifier: (->
    'activity-' + @get('id')
  ).property('id')
