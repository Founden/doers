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
        cardTypeName = '%@View'.fmt(type.classify())
        cardType = Doers.get(cardTypeName).create
          content: @content
        @pushObject(cardType)
    ).observes('content.type')
