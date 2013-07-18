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
        viewClassName = '%@View'.fmt(type.toLowerCase())
        viewClass = @get(viewClassName).create
          content: @content
        @pushObject(viewClass)
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