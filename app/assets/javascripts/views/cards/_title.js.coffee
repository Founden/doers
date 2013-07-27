Doers.CardTitleView = Ember.View.extend
  tagName: 'h2'
  template: Ember.Handlebars.compile('{{view.content.title}}')
  contentBinding: 'parentView.content'
  classNameBindings: ['isEditing:over']
  attributeBindings: ['contenteditable']
  contenteditable: 'true'
  isEditing: false

  focusIn: (event) ->
    @set('isEditing', true)

  focusOut: (event) ->
    @set('content.title', @$().text())
    @get('content').save()
    @set('isEditing', false)
