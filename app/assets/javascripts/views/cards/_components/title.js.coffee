Doers.CardTitleView = Ember.View.extend
  tagName: 'h2'
  templateName: 'cards/_title'
  contentBinding: 'parentView.content'
  classNames: ['title']