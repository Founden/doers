Doers.Project = DS.Model.extend
  title: DS.attr('string')
  description: DS.attr('string')
  website: DS.attr('string')
  status: DS.attr('string', readOnly: true)
  externalId: DS.attr('number', readOnly: true)
  updatedAt: DS.attr('date', readOnly: true)
  lastUpdate: DS.attr('string', readOnly: true)
  userNicename: DS.attr('string', readOnly: true)

  user: DS.belongsTo('Doers.User', readOnly: true)
  logo: DS.belongsTo('Doers.Logo', readOnly: true)
  boards: DS.hasMany('Doers.Board')

  deleteConfirmation: false

  slug: (->
    'project-' + @get('id')
  ).property('id')
