Doers.PhotoCardComponent = Doers.CardComponent.extend

  # Creates or updates an asset
  # @param data [Hash], a set of asset options
  #   Includes a key: `attr` the asset attribute name
  #                   `desc` the asset description
  #                   `url` the asset URI to use for `attachment`
  #                   `data` the asset base64 data to use for `attachment`
  createOrUpdateAsset: (data) ->
    card = @get('content')
    if card.get(data.attr)
      @updateAsset(data, card)
    else
      @createAsset(data, card)

  createAsset: (data) ->
    card = @get('content')
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

  updateAsset: (data) ->
    card = @get('content')
    asset = card.get(data.attr)
    asset.set('attachment', data.url || data.data)
    asset.set('description', data.desc || asset.get('description'))
    asset.save().then ->
      card.reload()


  actions:
    update: ->
      card = @get('content')
      data =
        attr: 'image',
        desc: card.get('attachmentDescription'),
        data: card.get('attachment')
      if card.get('isNew')
        card.save().then =>
          @createOrUpdateAsset(data)
      else
        @createOrUpdateAsset(data)
