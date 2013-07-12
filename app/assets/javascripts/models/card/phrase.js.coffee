Doers.PhraseMixin = Ember.Mixin.create
  content: DS.attr('string')

Doers.Phrase = Doers.Card.extend(Doers.PhraseMixin)
