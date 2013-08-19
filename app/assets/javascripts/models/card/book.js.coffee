Doers.BookMixin = Ember.Mixin.create
  url: DS.attr('string')
  bookTitle: DS.attr('string')
  bookAuthors: DS.attr('string')
  image: DS.belongsTo('Doers.Asset', readOnly: true)
  query: null
  results: null
  isSearching: false

  queryChanged: ( ->
    Ember.run.debounce(@, 'search', 200)
  ).observes('query')

  search: ->
    @set('isSearching', true)
    $.ajax
      url: 'https://www.googleapis.com/books/v1/volumes'
      dataType: 'jsonp'
      data:
        q: @get('query')
      success: (response) =>
        @set('results', response.items)
        @set('isSearching', false)
      failure: =>
        @set('results', null)

Doers.Book = Doers.Card.extend(Doers.BookMixin)
