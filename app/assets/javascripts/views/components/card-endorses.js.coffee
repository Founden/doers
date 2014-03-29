Doers.CardEndorsesComponent = Ember.Component.extend
  classNames: ['card-endorses']
  tagName: ['ul']
  isOwnerBinding: 'parentView.isOwner'

  userEndorse: ( ->
    @get('content.endorses').findBy('user', @get('user'))
  ).property('content.endorses.@each', 'user')

  actions:
    create: ->
      card = @get('content')
      topic = @get('content.topic')
      endorse = @get('content.store').createRecord 'endorse',
        project: card.get('project')
        board: card.get('board')
        topic: card.get('topic')
        card: card
      endorse.save().then ->
        card.reload()
        topic.reload()

    destroy: ->
      endorse = @get('userEndorse')
      card = @get('content')
      topic = @get('content.topic')
      endorse.deleteRecord()
      endorse.save().then ->
        card.reload()
        topic.reload()
