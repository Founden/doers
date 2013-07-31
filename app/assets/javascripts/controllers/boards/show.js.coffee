Doers.BoardsShowController = Ember.ObjectController.extend Doers.ControllerAlertMixin,

  saveCard: ->
    @get('content').save().then =>
      @set('isEditing', false)

  updateVideo: (video, data) ->
    # TODO: Set videoId
    video.set('provider', 'youtube')
    video.set('content', data.title.$t)
    video.set('query', null)
    if thumbnailUrl = data.media$group.media$thumbnail[0].url
      asset_data = {attr: 'image', desc: data.title, url: thumbnailUrl}
      @createOrUpdateAsset(video, asset_data)

  updateBook: (book, data) ->
    data = data.volumeInfo
    book.set('bookTitle', data.title)
    book.set('bookAuthors', data.authors)
    book.set('url', data.infoLink)
    book.set('query', null)
    if thumbnailUrl = data.imageLinks.thumbnail
      asset_data = {attr: 'image', desc: data.title, url: thumbnailUrl}
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
    # TODO: update to below once Ember.js#2957 gets released
    # klass = @get('container').resolve('model:asset')
    klass = Doers.Asset
    asset = klass.createRecord
      attachment: data.url || data.data
      description: data.desc
      project: object.get('project')
      board: object.get('board')
      assetableType: object.get('assetableType')
      assetableId: object.get('id')
    asset.save().then =>
      object.set(attribute, asset)

  updateAsset: (object, data) ->
    asset = object.get(data.attr)
    asset.set('attachment', data.url || data.data)
    asset.set('description', data.desc || asset.get('description'))
    asset.save()
