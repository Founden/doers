Doers.Photo = Doers.Card.extend
  image: DS.belongsTo('image', readOnly: true, polymorphic: true)
  attachment: null
  attachmentDescription: null
