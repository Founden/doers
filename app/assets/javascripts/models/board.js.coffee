Doers.Board = DS.Model.extend
  title: DS.attr('string')
  description: DS.attr('string')
  updatedAt: DS.attr('date')
  
  user: DS.belongsTo('Doers.User')
  author: DS.belongsTo('Doers.User')
  project: DS.belongsTo('Doers.Project')
  parentBoard: DS.belongsTo('Doers.Board')
  branches: DS.hasMany('Doers.Board')