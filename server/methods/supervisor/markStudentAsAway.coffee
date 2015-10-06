Meteor.methods
  markStudentAsAway: (studentId, shiftId)->
    check studentId, String
    check shiftId, String

    if Meteor.users.findOne(Meteor.userId()).profile.role == 'admin' || Meteor.users.findOne(Meteor.userId()).profile.role == 'supervisor'
      isStudentAlreadyMarkedAsAway = Shifts.findOne(shiftId)?.awayStudents?.indexOf(studentId) > -1
      if !isStudentAlreadyMarkedAsAway
        Shifts.update({"_id":shiftId},{$addToSet: {'awayStudents':studentId}})
      else
        Shifts.update({"_id":shiftId},{$pull: {'awayStudents':studentId}})
