Doers.BoardsShowController = Ember.ObjectController.extend Doers.ControllerAlertMixin,
  saveCard: ->
    @get('content').save().then =>
      @set('isEditing', false)

  updateBook: (book, data) ->
    data = data.volumeInfo
    book.set('bookTitle', data.title)
    book.set('bookAuthors', data.authors)
    book.set('url', data.infoLink)
    @createAsset(book, 'image', data.imageLinks.thumbnail)

  createAsset: (object, attribute, attachment) ->
    asset = Doers.Asset.createRecord
      attachment: attachment
      project: object.get('project')
      board: object.get('board')
      assetableType: object.get('assetableType')
      assetableId: object.get('id')
    asset.save().then =>
      object.set(attribute, asset)
