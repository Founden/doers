Doers.ProgressBarComponent = Ember.Component.extend
  width: 0
  attributeBindings: ['style']
  style: ( ->
    'width: %@%'.fmt(@get('width'))
  ).property('width')
