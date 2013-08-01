Doers.CardView = Ember.ContainerView.extend
  classNames: ['card']
  classNameBindings: [
    'typeClassName', 'isEditing:edit', 'content.style', 'content.slug']
  childViews: ['settingsView', 'contentView', 'editView']
  isEditing: false

  typeClassName: ( ->
    if type = @get('content.type')
      @get('content.type').dasherize()
  ).property('content.type')
