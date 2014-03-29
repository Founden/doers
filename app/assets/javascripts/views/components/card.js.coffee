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
      card.save().then =>
        card.set('isEditing', false)
        card.get('topic').reload()

    destroy: ->
      card = @get('content')
      topic = card.get('topic')
      if card.get('isNew')
        topic.get('cards').removeObject(card)
      else
        card.deleteRecord()
        card.save().then =>
          topic.reload()

    toggleAlignment: ->
      card = @get('content')
      topic = @get('content.topic')

      if card.get('isAlignedCard')
        topic.set('alignedCard', null)
      else
        topic.set('alignedCard', card)

      topic.save().then ->
        topic.get('board').reload()
        topic.reload()
