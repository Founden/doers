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

  user: DS.belongsTo('user', readOnly: true, inverse: 'createdProjects')
  boards: DS.hasMany('board', inverse: 'project', async: true)
  activities: DS.hasMany('activity', readOnly: true, inverse: 'project', async: true)
  memberships: DS.hasMany('membership', readOnly: true, inverse: 'project', async: true)
  logo: DS.belongsTo('logo', readOnly: true)

  slug: (->
    'project-' + @get('id')
  ).property('id')
