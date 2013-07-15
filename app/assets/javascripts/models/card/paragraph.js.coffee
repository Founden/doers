Doers.ParagraphMixin = Ember.Mixin.create
  content: DS.attr('string')

Doers.Paragraph = Doers.Card.extend(Doers.ParagraphMixin)
