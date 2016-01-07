Meteor.methods
  automaticallyAssignStudentsToShift: (shiftId, studentN) ->
    check shiftId, String
    check studentN, Number
    # Protect this method
    if Meteor.users.findOne(Meteor.userId()).profile.role == 'admin'
      # console.log 'yes'
      # To segment the problem a bit further we introduce a helper
      userHasNoOverlapsWithThisShift = (_id, shiftId) ->
        check _id, String
        check shiftId, String
        alreadyAssignedShifts = Shifts.find({'assignedStudents': $in: [ _id ]}).fetch()
        potentialNewShift = Shifts.findOne(shiftId)

        potentialNewShiftStartAsUNIX = potentialNewShift.info.start.getTime()
        # console.log 'potentialNewShiftStartAsUNIX', potentialNewShiftStartAsUNIX
        potentialNewShiftEndAsUNIX = potentialNewShift.info.end.getTime()
        # console.log 'potentialNewShiftEndAsUNIX', potentialNewShiftEndAsUNIX

        for alreadyAssignedShift in alreadyAssignedShifts
          oldShiftStartAsUNIX = alreadyAssignedShift.info.start.getTime()
          oldShiftEndAsUNIX = alreadyAssignedShift.info.start.getTime()
          if potentialNewShiftStartAsUNIX > oldShiftStartAsUNIX && potentialNewShiftStartAsUNIX < oldShiftEndAsUNIX
            return false
          if potentialNewShiftEndAsUNIX > oldShiftStartAsUNIX && potentialNewShiftEndAsUNIX < oldShiftEndAsUNIX
            return false
          if potentialNewShiftStartAsUNIX < oldShiftStartAsUNIX && potentialNewShiftEndAsUNIX > oldShiftEndAsUNIX
            return false
        return true
      getNextAvailableStudentForShift = (shiftId) ->
        genderspecification = Shifts.findOne(shiftId)?.info?.gender
        possibleStudentsWithLowestWorkload = []
        if genderspecification == 'male' || genderspecification == "female"
          # console.log 'Case: genderspecific'
          possibleStudentsWithLowestWorkload = Students.find({ $query: {$and: [{'gender':genderspecification},{$or: [{'exemptionStatus':{$exists: false}},{'exemptionStatus':''}]}]}})?.fetch()
        else
          # console.log 'Case: not genderspecific'
          possibleStudentsWithLowestWorkload = Students.find({ $query: {$or: [{'exemptionStatus':{$exists: false}},{'exemptionStatus':''}]}, $orderby: { workload : 1 }})?.fetch()

        possibleStudentsWithLowestWorkload.sort (a,b) ->
          return if parseInt(a.workload) >= parseInt(b.workload) then 1 else -1
        # console.log 'possibleStudentsWithLowestWorkload', possibleStudentsWithLowestWorkload

        for potentialFit in possibleStudentsWithLowestWorkload
          if Shifts.findOne(shiftId).assignedStudents.indexOf(potentialFit._id) == -1
            # console.log 'The student with the lowest workload is:', potentialFit
            # Commented because we do not care about overlaps right now
            # if userHasNoOverlapsWithThisShift(potentialFit._id, shiftId)
            return potentialFit
        throw new Meteor.Error 'Insufficient Students - a student can not be divided'

      if shiftId == '' || shiftId == undefined
        throw new Meteor.Error 'shiftId invalid'
      if studentN == '' || studentN == 0|| studentN == undefined || isNaN studentN
        throw new Meteor.Error 'studentN invalid'

      # console.log 'validation passed'

      for i in [0...studentN]
        # console.log 'in loop', i
        nextStudent = getNextAvailableStudentForShift(shiftId)
        # console.log 'nextStudent', nextStudent._id
        Shifts.update shiftId, $addToSet: assignedStudents:nextStudent?._id
        shift = Shifts.findOne(shiftId)
        shiftDuration = shift.info.end - shift.info.start
        shiftDurationInHours = Math.round(parseInt(shiftDuration)/1000/3600)
        # console.log 'shiftDurationInHours', shiftDurationInHours
        currentWorkloadOfStudent = Students.findOne(nextStudent?._id)?.workload
        # console.log 'currentWorkloadOfStudent', currentWorkloadOfStudent
        # console.log 'shiftId', shiftId
        if !currentWorkloadOfStudent
          currentWorkloadOfStudent = 0
        # if currentWorkloadOfStudent < 0
          # console.log 'ANOMALY:', shiftId, nextStudent?._id
          # console.log 'user', nextStudent
          # console.log 'shift', shiftId
          Meteor.Error 'stop'
        # console.log 'currentWorkloadOfStudent', currentWorkloadOfStudent
        newWorkloadOfStudent = String(parseInt(currentWorkloadOfStudent) + shiftDurationInHours)
        # console.log 'newWorkloadOfStudent', newWorkloadOfStudent
        Students.update({'_id':nextStudent?._id},{$set: {'workload':newWorkloadOfStudent}})

        # console.log 'shift.info.end', shift.info.end
        # console.log 'shift.info.start', shift.info.start
        # console.log 'shiftDuration', shiftDuration
        # console.log 'shiftDurationInHours', shiftDurationInHours

  automaticallyAssignStudentsToShifts: ->
    if Meteor.users.findOne(Meteor.userId()).profile.role == 'admin'
      allShifts = Shifts.find().fetch()
      for shift in allShifts
        N = 0
        N += parseInt(shift?.info?.requiredAmountOfStudents)
        N -= parseInt(shift?.assignedStudents?.length)
        if N > 0
          Meteor.call 'automaticallyAssignStudentsToShift', String(shift._id), parseInt(N)
      # console.log 'todo'
