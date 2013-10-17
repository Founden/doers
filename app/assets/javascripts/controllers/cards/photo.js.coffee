Doers.PhotoCardController =
Doers.CardController.extend Doers.ControllerAlertMixin,

  actions:
    update: ->
      card = @get('content')

      data =
        attr: 'image',
        desc: card.get('attachmentDescription'),
        data: card.get('attachment')

      if card.get('isNew')
        card.save().then =>
          @createOrUpdateAsset(data, card)
      else
        @createOrUpdateAsset(data, card)
