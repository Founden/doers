Doers.BoardsShowView = Ember.View.extend

  cardView: Ember.ContainerView.extend
    classNames: ['card']
    classNameBindings: ['typeClassName']

    typeClassName: ( ->
      if type = @get('content.type')
        @get('content.type').dasherize()
    ).property('content.type')

    didInsertElement: ( ->
      if type = @get('content.type')
        cardTypeName = '%@View'.fmt(type.toLowerCase())
        cardType = @get(cardTypeName).create
          content: @content
        @pushObject(cardType)
    ).observes('content.type')

    phraseView: Ember.View.extend
      templateName: 'cards/phrase'

    paragraphView: Ember.View.extend
      templateName: 'cards/paragraph'

    timestampView: Ember.View.extend
      templateName: 'cards/timestamp'

    intervalView: Ember.View.extend
      templateName: 'cards/interval'

    numberView: Ember.View.extend
      templateName: 'cards/number'

    linkView: Ember.View.extend
      templateName: 'cards/link'

    bookView: Ember.View.extend
      templateName: 'cards/book'

    mapView: Ember.View.extend
      templateName: 'cards/map'

    photoView: Ember.View.extend
      templateName: 'cards/photo'

    videoView: Ember.View.extend
      templateName: 'cards/video'
