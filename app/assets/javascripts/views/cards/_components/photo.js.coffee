Doers.CardPhotoView = Ember.View.extend
  tagName: 'img'
  classNames: ['image']
  attributeBindings: ['src']
  src: ( ->
    @get('content.attachment') ||
      @get('content.image.attachment')
  ).property('content.attachment', 'content.image.attachment', 'content.attachmentDescription')
