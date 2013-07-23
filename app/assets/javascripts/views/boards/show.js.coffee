Doers.BoardsShowView = Ember.View.extend
  cardView: Ember.ContainerView.extend
    isAdded: false
    classNames: ['card']
    classNameBindings: ['typeClassName']

    typeClassName: ( ->
      if type = @get('content.type')
        @get('content.type').dasherize()
    ).property('content.type')

    addCardView: ( ->
      if (type = @get('content.type')) and !@get('isAdded')
        klass = @container.resolve('view:%@'.fmt(type.toLowerCase()))
        view = @createChildView(klass, content: @get('content'))
        @pushObject(view)
        @set('isAdded', true)
    ).observes('content.type')
