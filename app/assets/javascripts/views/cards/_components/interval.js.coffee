Doers.CardIntervalView = Ember.View.extend
  contentBinding: 'parentView.content'
  templateName: 'cards/_interval'
  width: ( ->
    'width:%@%'.fmt(@get('content.percent'))
  ).property('content.percent')

