Doers.CardsController = Ember.ArrayController.extend

  save: ->
    @set('content.isEditing', false)
    @get('content').save().then =>
      currentUser = @container.resolve('user:current')
      @set('content.user', currentUser)

  addCard: (type) ->
    klass = @container.resolve('model:' + type)
    card = klass.createRecord
      user: @get('board.author')
      type: type
      position: @get('content.length')
    @get('content').pushObject(card)

  removeCard: (card) ->
    notNew = !!card.get('id')
    card.deleteRecord()
    card.save() if notNew
    @get('content').removeObject(card)

  addListItem: (card) ->
    item = Ember.Object.create({label: null, checked: true})
    card.get('items').pushObject(item)

  removeListItem: (card, item) ->
    card.get('items').removeObject(item)

  updateMap: (map, data) ->
    map.set('latitude', data.lat)
    map.set('longitude', data.lon)
    map.set('query', null)

  updateVideo: (video, data) ->
    video.set('provider', 'youtube')
    video.set('content', data.title.$t)
    video.set('query', null)

    if videoId = data.id['$t'].match(/videos\/(.*)/)
      video.set('videoId', videoId[1])

    if thumbnailUrl = data.media$group.media$thumbnail[0].url
      asset_data =
        attr: 'image',
        desc: data.title.$t,
        url: thumbnailUrl

    if video.get('isNew')
      video.save().then =>
        @createOrUpdateAsset(video, asset_data)
    else
      @createOrUpdateAsset(video, asset_data)

  updateBook: (book, data) ->
    data = data.volumeInfo
    book.set('bookTitle', data.title)
    book.set('bookAuthors', data.authors.join(', '))
    book.set('url', data.infoLink)
    book.set('query', null)

    if thumbnailUrl = data.imageLinks.thumbnail
      asset_data =
        attr: 'image',
        desc: data.title,
        url: thumbnailUrl

    if book.get('isNew')
      book.save().then =>
        @createOrUpdateAsset(book, asset_data)
    else
      @createOrUpdateAsset(book, asset_data)

  updatePhoto: (photo) ->
    asset_data =
      attr: 'image',
      desc: photo.get('attachmentDescription'),
      data: photo.get('attachment')
    @createOrUpdateAsset(photo, asset_data)

  # Creates or updates an asset
  # @param object [Object], our record
  # @param data [Hash], a set of asset options
  #   Includes a key: `attr` the asset attribute name for `object`
  #                   `desc` the asset description
  #                   `url` the asset URI to use for `attachment`
  #                   `data` the asset base64 data to use for `attachment`
  createOrUpdateAsset: (object, data) ->
    if object.get(data.attr)
      @updateAsset(object, data)
    else
      @createAsset(object, data)

  createAsset: (object, data) ->
    klass = @container.resolve('model:asset')
    asset = klass.createRecord
      attachment: data.url || data.data
      description: data.desc
      project: object.get('project')
      board: object.get('board')
      assetableType: object.get('assetableType')
      assetableId: object.get('id')
      type: 'Image'
    asset.save().then =>
      object.set(data.attr, asset)

  updateAsset: (object, data) ->
    asset = object.get(data.attr)
    asset.set('attachment', data.url || data.data)
    asset.set('description', data.desc || asset.get('description'))
    asset.save()
