Doers.CardEndorsesComponent = Ember.Component.extend
  classNames: ['card-endorses']
  tagName: ['ul']

  userEndorse: ( ->
    @get('content.endorses').findBy('user', @get('user'))
  ).property('content.endorses.@each')

  actions:
    create: ->
      card = @get('content')
      endorse = @get('content.store').createRecord 'endorse',
        project: card.get('project')
        board: card.get('board')
        topic: card.get('topic')
        card: card
      endorse.save().then ->
        card.reload()

    destroy: ->
      endorse = @get('userEndorse')
      endorse.deleteRecord()
      endorse.save().then =>
        card.reload()
