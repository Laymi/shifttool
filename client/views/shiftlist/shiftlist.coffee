Template.Shiftlist.helpers
  shifts: ->
    shifts = Shifts.find().fetch()
    if shifts.length then shifts else null

  userId: ->
    Router?.current()?.params?._id

  formatDate: (date) ->
    moment(date).format('MM-DD-YYYY hh:mm:ss')

Template.Shiftlist.events
  "click .editbtn": (event) ->
    event.preventDefault()

    Meteor.call 'deleteShiftById', event.target.name
    document.getElementById('_id').value = document.getElementById(event.target.name + '-' + '_id').innerText
    document.getElementById('supervisor').value = document.getElementById(event.target.name + '-' + 'supervisor').innerText
    document.getElementById('supervisorContact').value = document.getElementById(event.target.name + '-' + 'supervisorContact').innerText
    document.getElementById('location').value = document.getElementById(event.target.name + '-' + 'location').innerText
    document.getElementById('start').value = document.getElementById(event.target.name + '-' + 'start').innerText
    document.getElementById('end').value = document.getElementById(event.target.name + '-' + 'end').innerText
    document.getElementById('shiftname').value = document.getElementById(event.target.name + '-' + 'shiftname').innerText
    document.getElementById('remarks').value = document.getElementById(event.target.name + '-' + 'remarks').innerText
    document.getElementById('gender').value = document.getElementById(event.target.name + '-' + 'gender').innerText
    document.getElementById('requiredAmountOfStudents').value = document.getElementById(event.target.name + '-' + 'requiredAmountOfStudents').innerText

  "click .deletebtn": (event) ->
    event.preventDefault()
    if confirm 'Do you really want to delete the shift ' + event.target.name
      Meteor.call 'deleteShiftById', event.target.name

  "click #addNewShift": (event) ->
    event.preventDefault()
    newShift =
      "_id": document.getElementById('_id').value or Random.id()
      "info" : {
        "supervisor" : document.getElementById('supervisor').value
        "supervisorContact" : document.getElementById('supervisorContact').value
        "location" : document.getElementById('location').value
        "shiftname" : document.getElementById('shiftname').value
        "remarks" : document.getElementById('remarks').value
        "gender" : document.getElementById('gender').value
        "start": new Date document.getElementById('start').value
        "end": new Date document.getElementById('end').value
        "requiredAmountOfStudents": document.getElementById('requiredAmountOfStudents').value
      }
      "assignedStudents": []
      "createdAt": new Date

    Meteor.call 'addNewShift', newShift
    toastr.success 'Added!'
    document.getElementById('supervisor').value = ''
    document.getElementById('supervisorContact').value = ''
    document.getElementById('location').value = ''
    document.getElementById('remarks').value = ''
    document.getElementById('gender').value = ''
    document.getElementById('start').value = ''
    document.getElementById('end').value = ''
    document.getElementById('shiftname').value = ''
    document.getElementById('requiredAmountOfStudents').value = ''
    document.getElementById('_id').value = ''
