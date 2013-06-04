Doers.Project = DS.Model.extend
  angel_list_id: DS.attr('number')
  title: DS.attr('string')
  description: DS.attr('string')
  status: DS.attr('string')
  updatedAt: DS.attr('date')
  website: DS.attr('string')
  logoUrl: DS.attr('string')

  user: DS.belongsTo('Doers.User')

  slug: (->
    'project-' + @get('id')
  ).property('id')
