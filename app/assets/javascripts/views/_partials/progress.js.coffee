Doers.ProgressBar = Ember.View.extend
  width: 1
  classNames: ['progress-bar']
  attributeBindings: ['style']
  style: ( ->
    'width: %@%'.fmt(@get('width'))
  ).property('width')
