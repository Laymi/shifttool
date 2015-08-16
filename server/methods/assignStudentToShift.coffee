Meteor.methods
  assignStudentToShift: (manualStudentSelection, manualShiftSelection) ->
    check manualStudentSelection, String
    check manualShiftSelection, String
    Shifts.update manualShiftSelection, $addToSet: assignedStudents:manualStudentSelection
