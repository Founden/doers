Doers.TimestampView = Doers.CardView.extend
  contentView: Doers.CardContentView.extend
    childViews: ['titleView', 'timestampView', 'footerView']
    titleView: Doers.CardTitleView
    timestampView: Doers.CardTimestampView
    footerView: Doers.CardFooterView
  editView: Doers.CardEditView.extend
    datepicker: null
    timepicker: null
    didInsertElement: ->
      dateInputs = @$().find('input[type="date"]')
      timeInputs = @$().find('input[type="time"]')
      @datepicker = dateInputs.pickadate(
        today: false
        clear: false
      )
      @timepicker = timeInputs.pickatime()
