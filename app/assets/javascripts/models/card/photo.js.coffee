Doers.Photo = Doers.Card.extend
  image: DS.belongsTo('image', readOnly: true)
  attachment: null
  attachmentDescription: null
