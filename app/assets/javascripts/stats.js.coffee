#= require chart

((w, doc, $) ->
  DoersStats =
    users: null
    projects: null
    boards: null
    topics: null
    suggestions: null
    comments: null
    activities: null

    usersCanvas: $('#daily-users').get(0).getContext('2d')
    projectsCanvas: $('#daily-projects').get(0).getContext('2d')
    boardsCanvas: $('#daily-boards').get(0).getContext('2d')
    topicsCanvas: $('#daily-topics').get(0).getContext('2d')
    suggestionsCanvas: $('#daily-suggestions').get(0).getContext('2d')
    commentsCanvas: $('#daily-comments').get(0).getContext('2d')
    activitiesCanvas: $('#daily-activities').get(0).getContext('2d')

    options:
      scaleOverlay: true

    setup: ->
      $.getJSON window.location.href + '.json', (data) =>
        @users = new Chart(@usersCanvas).Bar(data.users, @options)
        @projects = new Chart(@projectsCanvas).Bar(data.projects, @options)
        @boards = new Chart(@boardsCanvas).Line(data.boards, @options)
        @topics = new Chart(@topicsCanvas).Bar(data.topics, @options)
        @suggestions = new Chart(@suggestionsCanvas).Line(data.suggestions, @options)
        @comments = new Chart(@commentsCanvas).Line(data.comments, @options)
        @activities = new Chart(@activitiesCanvas).Bar(data.activities, @options)

  DoersStats.setup()
) window, document, jQuery
