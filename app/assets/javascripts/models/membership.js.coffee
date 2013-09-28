Doers.Membership = DS.Model.extend
  updatedAt: DS.attr('date')

  creator: DS.belongsTo('Doers.User', readOnly: true)
  user: DS.belongsTo('Doers.User', readOnly: true)
  project: DS.belongsTo('Doers.Project', readOnly: true, inverse: 'memberships')
  board: DS.belongsTo('Doers.Board', readOnly: true, inverse: 'memberships')
