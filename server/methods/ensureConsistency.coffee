Meteor.methods
  'ensureConsistency': ->
    console.log 'ensureConsistency'
    allShiftStudents = Students.find({$or: [{'exemptionStatus':{$exists: false}},{'exemptionStatus':''}]}).fetch()
    console.log 'allShiftStudents', allShiftStudents
    for student in allShiftStudents
      allShiftsTheStudentIsIn = Shifts.find({'assignedStudents': student._id}).fetch()
      console.log 'allShiftsTheStudentIsIn', allShiftsTheStudentIsIn
      Students.update({'_id':student._id},{$set: 'workload':'0'})
      for shift in allShiftsTheStudentIsIn
        shiftDuration = shift.info.end - shift.info.start
        shiftDurationInHours = Math.round(parseInt(shiftDuration)/1000/3600)
        console.log 'shiftDurationInHours', shiftDurationInHours
        currentWorkloadOfStudent = Students.findOne(student?._id).workload
        console.log 'currentWorkloadOfStudent', currentWorkloadOfStudent
        newWorkloadOfStudent = String(parseInt(currentWorkloadOfStudent) + shiftDurationInHours)
        console.log 'newWorkloadOfStudent', newWorkloadOfStudent
        Students.update({'_id':student._id},{$set: 'workload':newWorkloadOfStudent})
    console.log 'done'

  'deleteEveryAssignment': ->
    Shifts.update({},{$set: {'assignedStudents':[]}},{multi: true})
