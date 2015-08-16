Meteor.methods
  automaticallyAssignStudentsToShift: (shiftId, studentN) ->
    check shiftId, String
    check studentN, Number

    if shiftId == '' || shiftId == undefined
      throw new Meteor.Error 'shiftId invalid'
    if studentN == '' || studentN == 0|| studentN == undefined || isNaN studentN
      throw new Meteor.Error 'studentN invalid'

    for i in [0...studentN]
      counter = 0
      possibleStudentWithLowestWorkload = Students.find({ $query: {}, $orderby: { workload : 1 }})?.fetch()?[counter]
      studentsAlreadyAssignedToShift = Shifts.findOne(shiftId)?.assignedStudents
      counter++
      while studentsAlreadyAssignedToShift.indexOf(possibleStudentWithLowestWorkload?._id) > -1
        possibleStudentWithLowestWorkload = Students.find({ $query: {}, $orderby: { workload : 1 }})?.fetch()?[counter]
        counter++
      studentWithLowestWorkload = possibleStudentWithLowestWorkload
      if studentWithLowestWorkload?._id?
        Shifts.update shiftId, $addToSet: assignedStudents:studentWithLowestWorkload?._id
      else
        throw new Meteor.Error 'Insufficient students available'
