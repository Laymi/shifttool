Template.supervisorDetail.helpers
  shift: ->
    shiftId = Router?.current()?.params?._id
    shift = Shifts.findOne(shiftId)
    # console.log 'shift', shift
    return shift

  getAttributeOfStudent: (attribute, _id) ->
    # console.log 'attribute', attribute, 'for', _id
    return Students.findOne(_id)[attribute]

  studentIsMarkedAsAttendant: (studentId) ->
    shiftId = Router?.current()?.params?._id
    # console.log 'studentId', studentId
    return Shifts.findOne(shiftId).attendantStudents?.indexOf(studentId) > -1

  studentIsMarkedAsAway: (studentId) ->
    shiftId = Router?.current()?.params?._id
    # console.log 'studentId', studentId
    return Shifts.findOne(shiftId).awayStudents?.indexOf(studentId) > -1

  studentIsMarkedAsTechSavvy: (studentId) ->
    return Students.findOne(studentId)?.techSavvy

Template.supervisorDetail.events
  "click .markStudentAsAttendant": (event) ->
    event.preventDefault()
    studentId = event.target.name
    shiftId = Router?.current()?.params?._id
    Meteor.call('markStudentAsAttendant', studentId, shiftId)

  "click .markStudentAsAway": (event) ->
    event.preventDefault()
    studentId = event.target.name
    shiftId = Router?.current()?.params?._id
    Meteor.call('markStudentAsAway', studentId, shiftId)

  "click .markStudentAsTechSavvy": (event) ->
    event.preventDefault()
    studentId = event.target.name
    Meteor.call('markStudentAsTechSavvy', studentId)
