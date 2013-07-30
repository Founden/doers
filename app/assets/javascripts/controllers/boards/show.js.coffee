Doers.BoardsShowController = Ember.ObjectController.extend Doers.ControllerAlertMixin,

  saveCard: ->
    @get('content').save().then =>
      @set('isEditing', false)

  updateVideo: (video, data) ->
    # TODO: Set videoId
    video.set('provider', 'youtube')
    video.set('content', data.title.$t)
    video.set('query', null)
    if image = data.media$group.media$thumbnail[0].url
      @createOrUpdateAsset(video, 'image', image)

  updateBook: (book, data) ->
    data = data.volumeInfo
    book.set('bookTitle', data.title)
    book.set('bookAuthors', data.authors)
    book.set('url', data.infoLink)
    book.set('query', null)
    if image = data.imageLinks.thumbnail
      @createOrUpdateAsset(book, 'image', image)

  createOrUpdateAsset: (object, attribute, url) ->
    if object.get(attribute)
      @updateAsset(object, attribute, url)
    else
      @createAsset(object, attribute, url)

  createAsset: (object, attribute, url) ->
    asset = Doers.Asset.createRecord
      attachment: url
      project: object.get('project')
      board: object.get('board')
      assetableType: object.get('assetableType')
      assetableId: object.get('id')
    asset.save().then =>
      object.set(attribute, asset)

  updateAsset: (object, attribute, url) ->
    asset = object.get(attribute)
    asset.set('attachment', url)
    asset.save()