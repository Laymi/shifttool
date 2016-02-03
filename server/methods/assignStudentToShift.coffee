Meteor.methods
  assignStudentToShift: (manualStudentSelection, manualShiftSelection) ->
    if Meteor.users.findOne(Meteor.userId()).profile.role == 'admin'
      check manualStudentSelection, String
      check manualShiftSelection, String
      Shifts.update manualShiftSelection, $addToSet: assignedStudents:manualStudentSelection
