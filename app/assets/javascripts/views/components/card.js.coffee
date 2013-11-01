Doers.CardComponent = Ember.Component.extend
  classNames: ['card']
  classNameBindings: ['content.slug']

  isOwner: ( ->
    @get('content.user') == @get('user')
  ).property('content.user', 'user')

  actions:
    edit: ->
      @set('content.isEditing', true)

    save: ->
      card = @get('content')
      mixpanelEvent = card.get('isNew') ? 'CREATED' : 'UPDATED'
      card.save().then =>
        card.set('isEditing', false)
        card.get('topic').reload()
        mixpanel.track mixpanelEvent,
          TYPE: 'Card'
          ID: card.get('id')
          TITLE: card.get('title')

    destroy: ->
      card = @get('content')
      topic = card.get('topic')
      if card.get('isNew')
        topic.get('cards').removeObject(card)
      else
        card.deleteRecord()
        card.save().then =>
          topic.reload()
          mixpanel.track 'DELETED',
            TYPE: 'Card'
            ID: card.get('id')
            TITLE: card.get('title')

    toggleAlignment: ->
      card = @get('content')
      topic = @get('content.topic')

      if card.get('isAlignedCard')
        topic.set('alignedCard', null)
        mixpanelEvent = 'UNALIGNED'
      else
        topic.set('alignedCard', card)
        mixpanelEvent = 'ALIGNED'

      topic.save().then ->
        topic.get('board').reload()
        topic.reload()
        mixpanel.track mixpanelEvent,
          TYPE: 'Card'
          ID: card.get('id')
          TITLE: card.get('title')

