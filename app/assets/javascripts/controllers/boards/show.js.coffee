Doers.BoardsShowController = Ember.ObjectController.extend Doers.ControllerAlertMixin,

  saveCard: ->
    @get('content').save().then =>
      @set('isEditing', false)

  updateBook: (book, data) ->
    data = data.volumeInfo
    book.set('bookTitle', data.title)
    book.set('bookAuthors', data.authors)
    book.set('url', data.infoLink)
    book.set('selectedResult', true)
    if data.imageLinks
      @createOrUpdateAsset(book, 'image', data.imageLinks.thumbnail)

  createOrUpdateAsset: (object, attribute, url) ->
    @updateAsset(object, attribute, url) || @createAsset(object, attribute, url)

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
    if asset = object.get(attribute)
      asset.set('attachment', url)
      asset.save()
    else
      false
