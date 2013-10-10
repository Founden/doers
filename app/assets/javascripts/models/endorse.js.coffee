Doers.Endorse = Doers.Activity.extend
  card: DS.belongsTo('card', readOnly: true, inverse: 'endorses')
