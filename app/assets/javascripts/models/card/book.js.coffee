Doers.BookMixin = Ember.Mixin.create
  url: DS.attr('string')
  bookTitle: DS.attr('string')
  bookAuthors: DS.attr('string')
  image: DS.belongsTo('Doers.Asset', readOnly: true)

Doers.Book = Doers.Card.extend(Doers.BookMixin)
