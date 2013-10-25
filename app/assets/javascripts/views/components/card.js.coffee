Doers.CardComponent = Ember.Component.extend
  classNames: ['card']

  actions:
    edit: ->
      @set('content.isEditing', true)

    save: ->
      @get('content').save().then =>
        @set('content.isEditing', false)
        @get('content.topic').reload()

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
      card.toggleProperty('alignment')
      card.save().then ->
        card.get('board').reload()
        card.get('topic').reload()