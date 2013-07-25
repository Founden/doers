Doers.BoardsShowView = Ember.View.extend
  cardsView: Ember.CollectionView.extend
    classNames: ['cards']

    createChildView: (view, attrs) ->
      type = attrs.content.get('type').toLowerCase()
      view = @container.resolve('view:%@'.fmt(type)) || view
      @_super(view, attrs)

  cardTypesView: Ember.CollectionView.extend
    classNames: ['card-types']
    content: ['Book', 'Interval', 'Link', 'Map', 'Number', 'Paragraph', 'Photo', 'Phrase', 'Timestamp', 'Video']

    itemViewClass: Ember.View.extend
      tagName: 'a'
      template: Ember.Handlebars.compile("{{view.content}}")
      classNames: ['card-type']
      attributeBindings: 'draggable'
      draggable: 'true'
      isDragging: false
