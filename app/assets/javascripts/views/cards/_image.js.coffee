Doers.CardImageView = Ember.View.extend
  tagName: 'img'
  classNames: ['image']
  attributeBindings: ['src']
  srcBinding: 'content.image.attachment'
