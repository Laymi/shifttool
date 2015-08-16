# XXX Temporary publication
Meteor.publish 'allShifts', ->
  Shifts.find()

Meteor.publish 'findAllShiftsForStudent', (studentId) ->
  check studentId, String
  Shifts.find 'assignedStudents': $in: [ studentId ]
