Meteor.methods
  markStudentAsAttendant: (studentId, shiftId)->
    check studentId, String
    check shiftId, String

    if Meteor.users.findOne(Meteor.userId()).profile.role == 'admin' || Meteor.users.findOne(Meteor.userId()).profile.role == 'supervisor'
      isStudentAlreadyMarkedAsAttendant = Shifts.findOne(shiftId)?.attendantStudents?.indexOf(studentId) > -1
      if !isStudentAlreadyMarkedAsAttendant
        Shifts.update({"_id":shiftId},{$addToSet: {'attendantStudents':studentId}})
      else
        Shifts.update({"_id":shiftId},{$pull: {'attendantStudents':studentId}})
