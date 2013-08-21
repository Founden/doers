Doers.Activity = DS.Model.extend
  slug: DS.attr('string', readOnly: true)
  lastUpdate: DS.attr('string', readOnly: true)

  user: DS.belongsTo('Doers.User', readOnly: true, inverse: 'activities')
  project: DS.belongsTo('Doers.User', readOnly: true, inverse: 'activities')
  board: DS.belongsTo('Doers.User', readOnly: true, inverse: 'activities')
  trackableId: DS.attr('number', readOnly: true)
  trackableType: DS.attr('string', readOnly: true)

  slug: (->
    'activity-' + @get('id')
  ).property('id')
