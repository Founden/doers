Doers.Project = DS.Model.extend
  angelListId: DS.attr('number')
  title: DS.attr('string')
  description: DS.attr('string')
  status: DS.attr('string')
  updatedAt: DS.attr('date')
  lastUpdate: DS.attr('string')
  website: DS.attr('string')
  logoUrl: DS.attr('string')
  userNicename: DS.attr('string')

  user: DS.belongsTo('Doers.User')

  boards: DS.hasMany('Doers.Board')

  slug: (->
    'project-' + @get('id')
  ).property('id')
