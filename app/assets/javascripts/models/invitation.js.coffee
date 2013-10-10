Doers.Invitation = DS.Model.extend
  email: DS.attr('string')
  invitableId: DS.attr('number')
  invitableType: DS.attr('string')
  avatarUrl: DS.attr('string', readOnly: true)
  membership_id: DS.attr('number', readOnly: true)
  membership_type: DS.attr('string')

  user: DS.belongsTo('user', readOnly: true, inverse: 'invitations')
  project: DS.belongsTo('project', readOnly: true)
  board: DS.belongsTo('board', readOnly: true)
  membership: DS.belongsTo('membership', readOnly: true)
