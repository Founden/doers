Doers.CardImageView = Ember.View.extend
  tagName: 'img'
  attributeBindings: ['src']
  srcBinding: 'content.image.attachment'
