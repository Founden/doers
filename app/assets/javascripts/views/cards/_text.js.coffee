Doers.CardTextView = Ember.View.extend
  tagName: 'p'
  template: Ember.Handlebars.compile('{{view.content.content}}')
  contentBinding: 'parentView.content'
  classNames: ['text']