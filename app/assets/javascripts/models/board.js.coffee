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

    if target and source
      targetAt = cards.indexOf(target)
      sourceAt = cards.indexOf(source)

      sourceStyle = source.get('style')

      target.set('position', sourceAt)
      source.set('position', targetAt)
      source.set('style', target.get('style'))
      target.set('style', sourceStyle)

      source.save() if source.get('id')
      target.save() if source.get('id')

    cards.setEach('moveSource', false)
    cards.setEach('moveTarget', false)
