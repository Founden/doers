Doers.BookMixin = Ember.Mixin.create
  url: DS.attr('string')
  bookTitle: DS.attr('string')
  bookAuthors: DS.attr('string')
  image: DS.belongsTo('Doers.Asset', readOnly: true)
  results: null

  bookTitleChanged: ( ->
    $.ajax
      url: 'https://www.googleapis.com/books/v1/volumes'
      dataType: 'jsonp'
      data:
        q: @get('bookTitle')
      success: (response) =>
        @set('results', response.items)
  ).observes('bookTitle')

Doers.Book = Doers.Card.extend(Doers.BookMixin)
