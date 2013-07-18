Doers.BookMixin = Ember.Mixin.create
  url: DS.attr('string')
  bookTitle: DS.attr('string')
  bookAuthors: DS.attr('string')
  imageUrl: DS.attr('string', readOnly: true)

  asset: DS.belongsTo('Doers.Asset')

Doers.Book = Doers.Card.extend(Doers.BookMixin)
