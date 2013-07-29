Doers.CardEmbedView = Ember.View.extend
  tagName: 'p'
  templateName: 'cards/_embed'
  contentBinding: 'parentView.content'
  embedBinding: 'content.embed'
  classNames: ['embed']
