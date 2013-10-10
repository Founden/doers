Doers.Team = DS.Model.extend
  title: DS.attr('string')
  description: DS.attr('string')
  slug: DS.attr('string')

  banner: DS.belongsTo('asset')
  boards: DS.hasMany('board', readOnly: true, inverse: 'team', async: true)
  users: DS.hasMany('user', async: true)
