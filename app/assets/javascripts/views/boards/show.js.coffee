Doers.BoardsShowView = Ember.View.extend
  cardsView: Ember.CollectionView.extend
    classNames: ['cards']

    createChildView: (view, attrs) ->
      type = attrs.content.get('type').toLowerCase()
      view = @container.resolve('view:%@'.fmt(type)) || view
      @_super(view, attrs)
