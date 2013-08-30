Doers.CardView = Ember.ContainerView.extend
  classNames: ['card-item']
  classNameBindings: [
    'typeClassName', 'isEditing:edit', 'content.style', 'content.slug']
  childViews: ['settingsView', 'contentView', 'editView']
  isEditingBinding: 'content.isEditing'
  isBuildingBinding: 'content.isBuilding'

  typeClassName: ( ->
    if type = @get('content.type')
      @get('content.type').dasherize()
  ).property('content.type')
