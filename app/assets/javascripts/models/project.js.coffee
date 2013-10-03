Doers.Project = DS.Model.extend
  title: DS.attr('string')
  description: DS.attr('string')
  website: DS.attr('string')
  status: DS.attr('string', readOnly: true)
  externalId: DS.attr('number', readOnly: true)
  updatedAt: DS.attr('date', readOnly: true)
  lastUpdate: DS.attr('string', readOnly: true)
  boardsCount: DS.attr('number', readOnly: true)
  membersCount: DS.attr('number', readOnly: true)

  user: DS.belongsTo('Doers.User', readOnly: true, inverse: 'createdProjects')
  logo: DS.belongsTo('Doers.Logo', readOnly: true, inverse: 'user')
  boards: DS.hasMany('Doers.Board', inverse: 'project')
  activities: DS.hasMany('Doers.Activity', readOnly: true, inverse: 'project')
  memberships: DS.hasMany('Doers.Membership', readOnly: true, inverse: 'project')

  slug: (->
    'project-' + @get('id')
  ).property('id')
