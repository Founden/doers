Doers.BoardsShowView = Ember.View.extend

  selectedCard: null

  cardItemView: Ember.View.extend
    classNames: ['card-item']

    templateName: ( ->
      if type = @get('content.type')
        'cards/%@'.fmt(@get('content.type'))
    ).property('content.type')

    templateNameDidChange: ( ->
      @rerender()
    ).observes('templateName')

    click: (event) ->
      @set('parentView.selectedCard', @get('content'))
      @set('content.isEditing', true)

  cardEditView: Ember.View.extend
    classNames: ['card']
    contentBinding: 'parentView.selectedCard'
    isVisibleBinding: 'content.isEditing'

    templateName: ( ->
      if type = @get('content.type')
        'cards/edit/phrase'.fmt(@get('content.type'))
    ).property('content.type')

    templateNameDidChange: ( ->
      @rerender()
    ).observes('templateName')

    closeView: Ember.View.extend
      click: (event) ->
        @set('parentView.content.isEditing', false)