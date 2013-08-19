Doers.BoardsBuildView = Ember.View.extend
  buildCardsView: Ember.CollectionView.extend
    classNames: ['cards', 'build']

    createChildView: (view, attrs) ->
      attrs.content.set('isBuilding', true)
      type = attrs.content.get('type')
      view = @container.resolve('view:%@'.fmt(type)) || view
      @_super(view, attrs)
