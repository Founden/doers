Doers.Board = DS.Model.extend
  title: DS.attr('string')
  description: DS.attr('string')

  parentBoard: DS.belongsTo('Doers.Board', inverse: 'branches')
  project: DS.belongsTo('Doers.Project', inverse: 'boards')
  user: DS.belongsTo('Doers.User', readOnly: true, inverse: 'boards')
  author: DS.belongsTo('Doers.User', readOnly: true, inverse: 'authoredBoards')

  updatedAt: DS.attr('date', readOnly: true)
  lastUpdate: DS.attr('string', readOnly: true)

  branches: DS.hasMany('Doers.Board', inverse: 'parentBoard')
  branchesCount: DS.attr('number', readOnly: true)
  cards: DS.hasMany('Doers.Card', inverse: 'board')
  cardsCount: DS.attr('number', readOnly: true)

  deleteConfirmation: false

  slug: (->
    'board-' + @get('id')
  ).property('id')

  cardsOrderChanged: ->
    cards = @get('cards')
    source = cards.filterProperty('moveSource', true).get('firstObject')
    target = cards.filterProperty('moveTarget', true).get('firstObject')

    if target and source and (target.get('id') != source.get('id'))
      targetAt = target.get('position')
      sourceAt = source.get('position')
      diff = targetAt - sourceAt

      # If we need to shift some cards in between
      if Math.abs(diff) != 1
        # Shift/Unshift any cards which position is affected
        cards.forEach (card) ->
          cardAt = card.get('position')
          # If source is before target (all goes desc order)
          if diff < 0 and cardAt < sourceAt and cardAt >= targetAt
            card.incrementProperty('position')
          # If source is after target (all goes desc order)
          if diff > 0 and cardAt > sourceAt and cardAt < targetAt
            card.decrementProperty('position')

        # Set source after target
        if diff < 0
          source.set('position', targetAt)
        else
          source.set('position', targetAt - 1)

      else
        source.set('position', targetAt)
        target.set('position', sourceAt)

      # Set source after target
      source.set('moveSource', false)
      target.set('moveTarget', false)

      source.save() if source.get('id')
      target.save() if source.get('id')
