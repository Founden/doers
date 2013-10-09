Doers.Activity = DS.Model.extend
  slug: DS.attr('string', readOnly: true)
  lastUpdate: DS.attr('string', readOnly: true)

  user: DS.belongsTo('Doers.User', readOnly: true, inverse: 'activities')
  project: DS.belongsTo('Doers.Project', readOnly: true, inverse: 'activities')
  board: DS.belongsTo('Doers.Board', readOnly: true, inverse: 'activities')
  topic: DS.belongsTo('Doers.Topic', readOnly: true, inverse: 'activities')
  card: DS.belongsTo('Doers.Card', readOnly: true, inverse: 'activities')
  comment: DS.belongsTo('Doers.Comment', readOnly: true)

  slug: (->
    'activity-' + @get('id')
  ).property('id')

  isCardCreation: ( ->
    /create-card/.test(@get('slug'))
  ).property('slug')

  isCardUpdate: ( ->
    /update-card/.test(@get('slug'))
  ).property('slug')
