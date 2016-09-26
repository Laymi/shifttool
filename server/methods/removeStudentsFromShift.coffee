Meteor.methods
  removeStudentsFromShift: (shiftId, studentN) ->
    studentFromSetWithHighestWorkload = (assignedStudents) ->
      if Meteor.users.findOne(Meteor.userId()).profile.role == 'admin'
        studentsWithWorkload = []
        for i in [0...assignedStudents.length]
          studentsWithWorkload[i] =
            _id:assignedStudents[i]
            workload: Students.findOne(assignedStudents[i]).workload
        studentsWithWorkload.sort (a,b) ->
          return if parseInt(a.workload) >= parseInt(b.workload) then -1 else 1
        return studentsWithWorkload[0]

    check shiftId, String
    check studentN, Number

    if Meteor.users.findOne(Meteor.userId()).profile.role == 'admin'
      for i in [0...studentN]
        currentlyAssignedStudents = Shifts.findOne(shiftId)?.assignedStudents
        studentIdToPull = studentFromSetWithHighestWorkload(currentlyAssignedStudents)._id
        # console.log 'studentIdToPull', studentIdToPull
        Shifts.update({"_id":shiftId},{$pull: { assignedStudents: studentIdToPull}})
        shift = Shifts.findOne(shiftId)
        shiftDuration = shift.info.end - shift.info.start
        shiftDurationInHours = Math.round(parseInt(shiftDuration)/1000/3600)
        # console.log 'shiftDurationInHours', shiftDurationInHours
        currentWorkloadOfStudent = Students.findOne(studentIdToPull)?.workload
        # console.log 'currentWorkloadOfStudent', currentWorkloadOfStudent
        newWorkloadOfStudent = String(parseInt(currentWorkloadOfStudent) - shiftDurationInHours)
        # console.log 'newWorkloadOfStudent', newWorkloadOfStudent
        Students.update({'_id':studentIdToPull},{$set: {'workload':newWorkloadOfStudent}})
