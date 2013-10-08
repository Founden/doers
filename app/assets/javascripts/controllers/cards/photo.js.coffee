Doers.PhotoCardController =
Doers.CardController.extend Doers.ControllerAlertMixin,

  update: ->
    card = @get('content')
    card.save().then =>
      data =
        attr: 'image',
        desc: card.get('attachmentDescription'),
        data: card.get('attachment')
      @createOrUpdateAsset(data)

