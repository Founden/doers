Doers.Photo = Doers.Card.extend
  image: DS.belongsTo('asset', readOnly: true)
  attachment: null
  attachmentDescription: null
