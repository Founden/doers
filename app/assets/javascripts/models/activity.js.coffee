Doers.Activity = DS.Model.extend Doers.LastUpdateMixin,
  slug: DS.attr('string', readOnly: true)
  updatedAt: DS.attr('date', readOnly: true)

  user: DS.belongsTo('user', readOnly: true, inverse: 'activities')
  project: DS.belongsTo('project', readOnly: true, inverse: 'activities')
  board: DS.belongsTo('board', readOnly: true, inverse: 'activities')
  comment: DS.belongsTo('comment', readOnly: true, inverse: 'activity')
  topic: DS.belongsTo('topic', readOnly: true, inverse: 'activities')

  identifier: (->
    'activity-' + @get('id')
  ).property('id')

  isCardCreation: ( ->
    /create-card/.test(@get('slug'))
  ).property('slug')

  isCardUpdate: ( ->
    /update-card/.test(@get('slug'))
  ).property('slug')

  isCardDestroy: ( ->
    /destroy-card/.test(@get('slug'))
  ).property('slug')

