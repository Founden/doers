Doers.CardMapView = Ember.View.extend
    tagName: 'img'
    classNames: ['image']
    attributeBindings: ['src']
    contentBinding: 'parentView.content'
    src: ( ->
      'http://maps.googleapis.com/maps/api/staticmap?' + @get('content.params')
    ).property('content.params')
