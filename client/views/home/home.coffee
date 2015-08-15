Template.Home.helpers

  shifts: ->
    shifts = Shifts.find().fetch()
    if shifts.length then shifts else null
  userId: ->
    Router?.current()?.params?._id
