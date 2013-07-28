Doers.Embed = DS.Model.extend
  url: DS.attr('string', readOnly: true)
  title: DS.attr('string', readOnly: true)
  html: DS.attr('string', readOnly: true)
  type: DS.attr('string', readOnly: true)
  providerName: DS.attr('string', readOnly: true)
  thumbUrl: DS.attr('string', readOnly: true)
  authorUrl: DS.attr('string', readOnly: true)
  authorName: DS.attr('string', readOnly: true)
  width: DS.attr('number', readOnly: true)
  height: DS.attr('number', readOnly: true)
