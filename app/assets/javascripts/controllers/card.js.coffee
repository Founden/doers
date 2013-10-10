Doers.CardController =
Ember.ObjectController.extend Doers.ControllerAlertMixin,

  save: ->
    @get('content').save().then =>
      currentUser = @container.resolve('user:current')
      @set('content.user', currentUser)

  destroy: ->
    card = @get('content')
    card.deleteRecord()
    card.get('store').commit()

  endorse: ->
    card = @get('content')
    klass = @container.resolve('model:endorse')
    endorse = klass.createRecord
      project: card.get('project')
      board: card.get('board')
      topic: card.get('topic')
      card: card
    endorse.save().then =>
      # card.get('endorses').pushObject(endorse)

  # Creates or updates an asset
  # @param data [Hash], a set of asset options
  #   Includes a key: `attr` the asset attribute name
  #                   `desc` the asset description
  #                   `url` the asset URI to use for `attachment`
  #                   `data` the asset base64 data to use for `attachment`
  createOrUpdateAsset: (data) ->
    if @get('content').get(data.attr)
      @updateAsset(data)
    else
      @createAsset(data)

  createAsset: (data) ->
    card = @get('content')
    asset = Doers.Asset.createRecord
      attachment: data.url || data.data
      description: data.desc
      project: card.get('project')
      board: card.get('board')
      assetableType: card.get('assetableType')
      assetableId: card.get('id')
      type: 'Image'
    asset.save().then =>
      card.set(data.attr, asset)

  updateAsset: (data) ->
    asset = @get('content').get(data.attr)
    asset.set('attachment', data.url || data.data)
    asset.set('description', data.desc || asset.get('description'))
    asset.save()
