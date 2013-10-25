Doers.Card = DS.Model.extend
  assetableType: 'Card'

  title: DS.attr('string')
  content: DS.attr('string')
  type: DS.attr('string')
  alignment: DS.attr('boolean', default: false)
  updatedAt: DS.attr('date', readOnly: true)

  project: DS.belongsTo('project')
  board: DS.belongsTo('board')
  topic: DS.belongsTo('topic', inverse: 'cards')
  user: DS.belongsTo('user', readOnly: true)
  comments: DS.hasMany('comment', readOnly: true, inverse: 'card', async: true)
  endorses: DS.hasMany('endorse', readOnly: true, inverse: 'card', async: true)

  isEditing: false

  slug: (->
    'card-' + @get('id')
  ).property('id', 'type')

  isParagraph: ( ->
    @get('type') == 'Paragraph'
  ).property('type')

  isPhoto: ( ->
    @get('type') == 'Photo'
  ).property('type')

  isMap: ( ->
    @get('type') == 'Map'
  ).property('type')

  isLink: ( ->
    @get('type') == 'Link'
  ).property('type')
