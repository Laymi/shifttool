Meteor.methods
  removeStudentFromAllShifts: (studentId) ->
    check studentId, String
    # console.log 'studentId', studentId

    if Meteor.users.findOne(Meteor.userId()).profile.role == 'admin'
      allShiftsTheStudentIsIn = Shifts.find({'assignedStudents': $in: [ studentId ]}).fetch()

      for i in [0...allShiftsTheStudentIsIn.length]
        Shifts.update({"_id":allShiftsTheStudentIsIn[i]._id},{$pull: { assignedStudents: studentId}})
        Meteor.call('automaticallyAssignStudentsToShift', allShiftsTheStudentIsIn[i]._id, 1)

      Students.update({'_id':studentId},{$set: {'workload': 0}})
