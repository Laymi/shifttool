Template.Supervisor.helpers
  shifts: ->
    shifts = Shifts.find({},{sort: {'info.start': 1}}).fetch()
    if shifts.length then shifts else null

  formatDate: (date) ->
    moment(date).subtract(2, 'hours').format('MM-DD-YYYY hh:mm:ss a')
