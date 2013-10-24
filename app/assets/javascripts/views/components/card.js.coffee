Doers.CardComponent = Ember.Component.extend
  classNames: ['card']

  userEndorse: ( ->
    currentUser = @container.resolve('user:current')
    @get('content.endorses').findBy('user', currentUser)
  ).property('content.endorses.@each')

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
      card.deleteRecord()
      if card.get('isNew')
        topic.set('card', null)
      else
        card.save().then =>
          topic.reload()

    addEndorse: ->
      card = @get('content')
      endorse = @store.createRecord 'endorse',
        project: card.get('project')
        board: card.get('board')
        topic: card.get('topic')
        card: card
      endorse.save().then ->
        card.reload()

    removeEndorse: ->
      endorse = @get('userEndorse')
      endorse.deleteRecord()
      endorse.save().then =>
        card.reload()

    toggleAlignment: ->
      card = @get('content')
      card.toggleProperty('alignment')
      card.save().then ->
        card.get('board').reload()
        card.get('topic').reload()

    # Creates or updates an asset
    # @param data [Hash], a set of asset options
    #   Includes a key: `attr` the asset attribute name
    #                   `desc` the asset description
    #                   `url` the asset URI to use for `attachment`
    #                   `data` the asset base64 data to use for `attachment`
    createOrUpdateAsset: (data, card) ->
      if card.get(data.attr)
        @updateAsset(data, card)
      else
        @createAsset(data, card)

    createAsset: (data, card) ->
      asset = @get('content.store').createRecord 'asset',
        attachment: data.url || data.data
        description: data.desc
        project: card.get('project')
        board: card.get('board')
        assetableType: card.get('assetableType')
        assetableId: card.get('id')
        type: 'Image'
      asset.save().then =>
        card.reload()

    updateAsset: (data, card) ->
      asset = card.get(data.attr)
      asset.set('attachment', data.url || data.data)
      asset.set('description', data.desc || asset.get('description'))
      asset.save().then ->
        card.reload()
