Doers.ProgressBar = Ember.View.extend
  width: 0
  attributeBindings: ['style']
  style: ( ->
    'width: %@%'.fmt(@get('width'))
  ).property('width')
