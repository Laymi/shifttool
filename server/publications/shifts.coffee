# XXX Temporary publication
Meteor.publish 'allShifts', ->
  if this.userId
    Shifts.find()
  else
    @ready()

Meteor.publish 'findAllShiftsForStudent', (studentId) ->
  check studentId, String
  if this.userId
    Shifts.find 'assignedStudents': $in: [ studentId ]
  else
    @ready()
