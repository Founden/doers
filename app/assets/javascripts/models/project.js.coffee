Doers.Project = DS.Model.extend
  title: DS.attr('string')
  description: DS.attr('string')
  status: DS.attr('string')
  updatedAt: DS.attr('date')

  user: DS.belongsTo('Doers.User')

  slug: (->
    'project-' + @get('id')
  ).property('id')
