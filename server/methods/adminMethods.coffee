Meteor.methods
  populateDatabase: (N = 0) ->
    if Meteor.users.findOne(Meteor.userId()).profile.role == 'admin'
      check N, Number
      for i in [0...N]
        newStudent =
          "_id": Random.id()
          "first_name" : Math.random().toString(36).substring(7)
          "last_name" : Math.random().toString(36).substring(7)
          "workload" : 0
          "exemptionStatus" : ""
          "createdAt": new Date

        Students.insert newStudent

        newShift =
          "_id": Random.id()
          "info" : {
            "supervisor" : Math.random().toString(36).substring(7) + ' ' + Math.random().toString(36).substring(7)
            "supervisorContact" : '+123456789'
            "location" : 'WHU'
            "info" : 'some info'
            "start": new Date
            "end": new Date
            "requiredAmountOfStudents": Math.random().toString(10).substring(3,4)
          }
          "assignedStudents": []
          "createdAt": new Date

        Shifts.insert newShift

  createExampleUser: ->
    Accounts.createUser
      email: 'test1337@test.test'
      password: 'test1234'

    console.log 'test@test.de', 'test1234'

  updateTimezone: ->
    if Meteor.users.findOne(Meteor.userId()).profile.role == 'admin'
      allShifts = Shifts.find().fetch()
      for shift in allShifts
        info = shift?.info

        info.start = new Date(info.start.setHours(info.start.getHours()+1))
        info.end = new Date(info.end.setHours(info.end.getHours()+1))

        Shifts.update shift._id, $set: info:info

  detectOverlaps: ->
    allUsers = Meteor.users.find().fetch()
    _.each allUsers, (user) ->
      shiftsOfUser = Shifts.find("assignedStudents":user._id).fetch()
      _.each shiftsOfUser, (shift) ->
        _.each shiftsOfUser, (secondShift) ->
          potentialNewShift = secondShift

          potentialNewShiftStartAsUNIX = potentialNewShift.info.start.getTime()
          # console.log 'potentialNewShiftStartAsUNIX', potentialNewShiftStartAsUNIX
          potentialNewShiftEndAsUNIX = potentialNewShift.info.end.getTime()
          # console.log 'potentialNewShiftEndAsUNIX', potentialNewShiftEndAsUNIX

          oldShiftStartAsUNIX = shift.info.start.getTime()
          oldShiftEndAsUNIX = shift.info.start.getTime()
          if potentialNewShiftStartAsUNIX >= oldShiftStartAsUNIX && potentialNewShiftStartAsUNIX <= oldShiftEndAsUNIX
            console.log 'overlap', user._id
          if potentialNewShiftEndAsUNIX >= oldShiftStartAsUNIX && potentialNewShiftEndAsUNIX <= oldShiftEndAsUNIX
            console.log 'overlap', user._id
          if potentialNewShiftStartAsUNIX <= oldShiftStartAsUNIX && potentialNewShiftEndAsUNIX >= oldShiftEndAsUNIX
            console.log 'overlap', user._id
