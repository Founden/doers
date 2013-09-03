Doers.Invitation = DS.Model.extend
  email: DS.attr('string')
  invitable_id: DS.attr('number')
  invitable_type: DS.attr('string')
  avatarUrl: DS.attr('string', readOnly: true)

  user: DS.belongsTo('Doers.User', readOnly: true, inverse: 'invitations')
  project: DS.belongsTo('Doers.Project', readOnly: true)
  board: DS.belongsTo('Doers.Board', readOnly: true)

  #TODO: materialize this
  membership_id: DS.attr('number')
  membership_type: DS.attr('string')
