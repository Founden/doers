Doers.MembersView = Ember.View.extend
  templateName: 'partials/members'
  isAdding: false

  addButtonView: Ember.View.extend
    classNames: ['button']
    click: (event) ->
      @toggleProperty('parentView.isAdding')
