Doers.Membership = DS.Model.extend
  updatedAt: DS.attr('date', readOnly: true)

  creator: DS.belongsTo('user', readOnly: true)
  user: DS.belongsTo('user', readOnly: true)
  project: DS.belongsTo('project', readOnly: true, inverse: 'memberships')
  board: DS.belongsTo('board', readOnly: true, inverse: 'memberships')
