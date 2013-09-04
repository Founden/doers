Doers.Invitation = DS.Model.extend
  email: DS.attr('string')
  invitable_id: DS.attr('number')
  invitable_type: DS.attr('string')
  avatarUrl: DS.attr('string', readOnly: true)

  user: DS.belongsTo('Doers.User', readOnly: true, inverse: 'invitations')
  project: DS.belongsTo('Doers.Project', readOnly: true)
  board: DS.belongsTo('Doers.Board', readOnly: true)
  membership: DS.belongsTo('Doers.Membership', readOnly: true)
  membership_id: DS.attr('number', readOnly: true)
  membership_type: DS.attr('string')
