Doers.EditCardViewMixin = Ember.Mixin.create
  contentBinding: 'parentView.content'
  classNames: ['card-edit']
  isVisibleBinding: 'parentView.isEditing'
  templateName: 'cards/edit/phrase'

  saveButtonView: Ember.View.extend
    tagNames: 'input'
    attributeBindings: ['type']
    type: 'submit'
    contentBinding: 'parentView.content'
    classNames: ['button']

    click: ->
      @get('content').save().then =>
        @set('parentView.parentView.isEditing', false)
