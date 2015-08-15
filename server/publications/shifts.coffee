# XXX Temporary publication
Meteor.publish 'allShifts', ->
  Shifts.find()

Meteor.publish 'findAllShiftsForStudent', (studentId) ->
  console.log 'studentId', studentId
  check studentId, String
  Shifts.find 'assignedStudents': $in: [ studentId ]
