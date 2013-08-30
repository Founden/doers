Doers.Team = DS.Model.extend
  title: DS.attr('string')
  description: DS.attr('string')
  slug: DS.attr('string')

  banner: DS.belongsTo('Doers.Asset')
  boards: DS.hasMany('Doers.Board')
  users: DS.hasMany('Doers.User')
