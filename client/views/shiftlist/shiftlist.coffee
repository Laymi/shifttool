#Meteor.subscribe 'allShifts'
Template.Shiftlist.helpers
  shifts: ->
    shifts = Shifts.find().fetch()
    if shifts.length then shifts else null

  userId: ->
    Router?.current()?.params?._id

  formatDate: (date) ->
    moment(date).format('MM-DD-YYYY hh:mm:ss')

Template.Shiftlist.events
  "click .deletebtn": (event) ->
    event.preventDefault()

    Meteor.call 'deleteShiftById', event.target.name

  "click #addNewShift": (event) ->
    event.preventDefault()
    newShift =
      "_id": Random.id()
      "info" : {
        "supervisor" : document.getElementById('supervisor').value
        "supervisorContact" : document.getElementById('supervisorContact').value
        "location" : document.getElementById('location').value
        "info" : document.getElementById('info').value
        "start": new Date document.getElementById('start').value
        "end": new Date document.getElementById('end').value
        "requiredAmountOfStudents": document.getElementById('requiredAmountOfStudents').value
      }
      "assignedStudents": []
      "createdAt": new Date

    Meteor.call 'addNewShift', newShift
