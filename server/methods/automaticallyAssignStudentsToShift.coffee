Meteor.methods
  automaticallyAssignStudentsToShift: (shiftId, studentN) ->
    check shiftId, String
    check studentN, Number
    # To segment the problem a bit further we introduce a helper
    getNextAvailableStudentForShift = (shiftId) ->
      genderspecification = Shifts.findOne(shiftId)?.info?.gender
      possibleStudentsWithLowestWorkload = []
      if genderspecification == 'male' || genderspecification == "female"
        console.log 'case1'
        possibleStudentsWithLowestWorkload = Students.find({ $query: {$and: [{'gender':genderspecification},{$or: [{'exemptionStatus':{$exists: false}},{'exemptionStatus':''}]}]}, $orderby: { workload : 1 }})?.fetch()
      else
        console.log 'case2'
        possibleStudentsWithLowestWorkload = Students.find({ $query: {$or: [{'exemptionStatus':{$exists: false}},{'exemptionStatus':''}]}, $orderby: { workload : 1 }})?.fetch()

      for potentialFit in possibleStudentsWithLowestWorkload
        # console.log 'potentialFit._id', potentialFit._id
        # console.log 'Shifts.findOne(shiftId).assignedStudents', Shifts.findOne(shiftId).assignedStudents
        if Shifts.findOne(shiftId).assignedStudents.indexOf(potentialFit._id) == -1
          # console.log 'The student with the lowest workload is:', potentialFit
          return potentialFit
      throw new Meteor.Error 'Insufficient Students - a student can not be divided'

    if shiftId == '' || shiftId == undefined
      throw new Meteor.Error 'shiftId invalid'
    if studentN == '' || studentN == 0|| studentN == undefined || isNaN studentN
      throw new Meteor.Error 'studentN invalid'

    # console.log 'validation passed'

    for i in [0...studentN]
      console.log 'in loop', i
      nextStudent = getNextAvailableStudentForShift(shiftId)
      console.log 'nextStudent', nextStudent._id
      Shifts.update shiftId, $addToSet: assignedStudents:nextStudent?._id
      shift = Shifts.findOne(shiftId)
      shiftDuration = shift.info.end - shift.info.start
      shiftDurationInHours = Math.round(parseInt(shiftDuration)/1000/3600)
      console.log 'shiftDurationInHours', shiftDurationInHours
      currentWorkloadOfStudent = Students.findOne(nextStudent?._id).workload or 0
      console.log 'currentWorkloadOfStudent', currentWorkloadOfStudent
      newWorkloadOfStudent = String(parseInt(currentWorkloadOfStudent) + shiftDurationInHours)
      console.log 'newWorkloadOfStudent', newWorkloadOfStudent
      Students.update({'_id':nextStudent?._id},{$set: {'workload':newWorkloadOfStudent}})

      # console.log 'shift.info.end', shift.info.end
      # console.log 'shift.info.start', shift.info.start
      # console.log 'shiftDuration', shiftDuration
      # console.log 'shiftDurationInHours', shiftDurationInHours

  automaticallyAssignStudentsToShifts: ->
    allShifts = Shifts.find().fetch()
    for shift in allShifts
      N = parseInt(shift?.info?.requiredAmountOfStudents) or 0
      Meteor.call 'automaticallyAssignStudentsToShift', String(shift._id), N
    console.log 'todo'
