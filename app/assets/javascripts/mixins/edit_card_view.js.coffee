Doers.EditCardViewMixin = Ember.Mixin.create
  contentBinding: 'parentView.content'
  classNames: ['card-edit']
  isVisibleBinding: 'parentView.isEditing'
  templateNameBinding: ( ->
    Ember.fmt('cards/edit/%s', @get('content.type'))
  ).property()
