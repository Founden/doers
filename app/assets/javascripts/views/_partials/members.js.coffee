Doers.MembersView = Ember.View.extend
  templateName: 'partials/members'

  addItemView: Ember.View.extend
    tagName: 'li'
    classNames: ['member-item-add']
    classNameBindings: ['isActive:active']
    isActive: false

    addButtonView: Ember.View.extend
      classNames: ['member-item-add-btn']
      click: (event) ->
        @toggleProperty('parentView.isActive')
